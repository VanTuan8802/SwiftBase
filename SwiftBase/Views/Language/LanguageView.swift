//
//  LanguageView.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI

struct LanguageView: View {

    /// Where this picker was opened from. Controls the copy, the leading button,
    /// and what happens when the user confirms / cancels.
    enum Mode {
        case onboarding
        case settings
    }

    let mode: Mode

    @EnvironmentObject private var coordinator: AppFlowCoordinator
    @Environment(\.dismiss) private var dismiss

    /// `true` once the user has tapped a row. In onboarding it starts `false` so
    /// the tap guide has something to point at and "Done" stays disabled.
    @State private var hasChosen = false

    /// The language active when the screen opened — restored if the user backs out
    /// of the Settings sheet.
    @State private var originalLanguage: AppLanguage = .deviceDefault

    /// Drives the "fly" of the tap guide from the row to the done button.
    @Namespace private var guideNS

    init(mode: Mode = .onboarding) {
        self.mode = mode
    }

    // The language the onboarding guide points at first.
    private let guideLanguage: AppLanguage = .english

    private var isGuiding: Bool { mode == .onboarding }
    private var showRowGuide: Bool { isGuiding && !hasChosen }
    private var showButtonGuide: Bool { isGuiding && hasChosen }
    private var canConfirm: Bool { hasChosen }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(AppLanguage.allCases) { language in
                        row(for: language)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
        .onAppear {
            originalLanguage = coordinator.language
            // Settings opens already on the current language; onboarding starts blank.
            if mode == .settings { hasChosen = true }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            BasicHeaderView(
                "language".localized,
                showBack: mode == .settings,
                backAction: { cancel() },
                trailingView: { doneButton }
            )

            if mode == .onboarding {
                Text("please_select_language".localized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(.top, mode == .settings ? 8 : 4)
    }

    /// Top-right confirm. Disabled until a language is chosen (onboarding); the tap
    /// guide flies here once a selection is made.
    private var doneButton: some View {
        Button {
            confirm()
        } label: {
            Image(systemName: "checkmark")
                .font(.title3.weight(.bold))
                .foregroundStyle(canConfirm ? Color.accentColor : Color.secondary.opacity(0.4))
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!canConfirm)
        .overlay(alignment: .center) {
            if showButtonGuide {
                tapGuide.offset(x: 16, y: 22)
            }
        }
    }

    private func row(for language: AppLanguage) -> some View {
        let isSelected = hasChosen && coordinator.language == language
        return Button {
            select(language)
        } label: {
            HStack(spacing: 14) {
                Text(language.flag)
                    .font(.title)
                Text(language.displayName)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.accentColor.opacity(0.12) : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.accentColor : .clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .overlay(alignment: .trailing) {
            if showRowGuide && language == guideLanguage {
                tapGuide.offset(x: -10, y: 6)
            }
        }
    }

    // MARK: - Actions

    /// Apply the picked language immediately (live preview).
    private func select(_ language: AppLanguage) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            hasChosen = true
            coordinator.updateLanguage(language)
        }
    }

    /// Top-right "Done": keep the applied language.
    private func confirm() {
        guard hasChosen else { return }
        switch mode {
        case .onboarding:
            // Already applied; persist + advance to the intro carousel.
            coordinator.didSelectLanguage(coordinator.language)
        case .settings:
            dismiss()
        }
    }

    /// Settings back button: discard the live changes and restore the original.
    private func cancel() {
        if coordinator.language != originalLanguage {
            coordinator.updateLanguage(originalLanguage)
        }
        dismiss()
    }

    /// The looping tap hand. The shared `matchedGeometryEffect` id lets it animate
    /// from the language row up to the done button when a selection is made.
    private var tapGuide: some View {
        LottieTapView(name: "tap")
            .frame(width: 64, height: 64)
            .clipped()
            .allowsHitTesting(false)
            .matchedGeometryEffect(id: "tapGuide", in: guideNS)
    }
}

#if DEBUG
#Preview("Onboarding") {
    LanguageView(mode: .onboarding)
        .environmentObject(AppFlowCoordinator())
}

#Preview("Settings") {
    LanguageView(mode: .settings)
        .environmentObject(AppFlowCoordinator())
}
#endif
