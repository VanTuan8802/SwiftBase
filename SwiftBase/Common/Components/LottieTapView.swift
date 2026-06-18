//
//  LottieTapView.swift
//  SwiftBase
//
//  Created by VanTuan on 18/6/26.
//

import SwiftUI
import Lottie

struct LottieTapView: UIViewRepresentable {
    /// File name (without extension) of the animation in the bundle.
    let name: String

    /// Optional recolor. When set, every colored layer of the animation is
    /// tinted to this color — used to match the app's accent / brand color.
    var tint: Color? = nil

    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView()
        // Try the bundle root first, then the `Json` subdirectory (depends on how
        // the build copies the resource folder).
        view.animation = LottieAnimation.named(name)
            ?? LottieAnimation.named(name, subdirectory: "Json")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.backgroundBehavior = .pauseAndRestore

        applyTint(to: view)

        // Lottie's intrinsic size is the animation's native size (here 600×600).
        // Drop the layout priorities so the SwiftUI `.frame(...)` wins instead of
        // the view spilling out at its natural size.
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        view.play()
        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        applyTint(to: uiView)
        if !uiView.isAnimationPlaying {
            uiView.play()
        }
    }

    /// Recolor every fill/stroke (`**.Color`) of the animation to `tint`.
    private func applyTint(to view: LottieAnimationView) {
        guard let tint else { return }
        let provider = ColorValueProvider(UIColor(tint).lottieColorValue)
        view.setValueProvider(provider, keypath: AnimationKeypath(keypath: "**.Color"))
    }
}
