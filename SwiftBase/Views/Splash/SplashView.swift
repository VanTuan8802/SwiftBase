//
//  SplashView.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var coordinator: AppFlowCoordinator
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.stack.3d.up.fill")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(Color.accentColor)
                .scaleEffect(appeared ? 1 : 0.7)
                .opacity(appeared ? 1 : 0)

            Text("SwiftBase")
                .font(.largeTitle.bold())
                .opacity(appeared ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appeared = true
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 1_400_000_000)
            coordinator.splashDidFinish()
        }
    }
}

#if DEBUG
#Preview {
    SplashView()
        .environmentObject(AppFlowCoordinator())
}
#endif
