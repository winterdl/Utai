//
//  EffectsView.swift
//  Utai
//
//  Created by Toto Minai on 2021/06/11.
//

import SwiftUI

struct EffectsView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        
        return view
    }
    
    func updateNSView(_ view: NSVisualEffectView, context: Context) {
        view.material = material
        view.blendingMode = blendingMode
    }
}

struct TranslucentBackground: View {
    var body: some View {
        ZStack {
            EffectsView(
                material: .underWindowBackground,
                blendingMode: .behindWindow)
            
            Rectangle()
                .foregroundColor(Color.black.opacity(0.1))
        }.ignoresSafeArea()
    }
}
