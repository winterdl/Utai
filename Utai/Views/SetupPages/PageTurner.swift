//
//  PageTurner.swift
//  Utai
//
//  Created by Toto Minai on 2021/06/11.
//

import SwiftUI

struct PageTurnerControl: View {
    @Binding var page: Int
    
    let target: Int
    let systemName: String
    let helpText: String
    
    var body: some View {
        ButtonMini(alwaysHover: page == target, systemName: systemName, helpText: helpText)
    }
}

struct ButtonMini: View {
    @State private var isHover = false
    var alwaysHover: Bool = false
    
    let systemName: String
    let helpText: String
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 12))
            .shadow(radius: 2)
            // TODO: Add helper text
            .help(helpText)
            .opacity(alwaysHover ? 1 : (isHover ? 1 : 0.3))
            .onHover { hovering in
                isHover = hovering
            }
            .animation(.easeOut, value: isHover)
    }
}

struct PageTurner: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 8) {
                PageTurnerControl(page: $store.page, target: 1, systemName: "circle.fill", helpText: "Import")
                    .onTapGesture {
                        store.page = 1
                        store.showMatchPanel = false
                    }
                
                PageTurnerControl(page: $store.page, target: 2, systemName: "triangle.fill", helpText: "Choose")
                    .onTapGesture {
                        if store.page != 2 {
                            store.page = 2
                        }
                    }
                    .disabled(store.album == nil)
                
                PageTurnerControl(page: $store.page, target: 3, systemName: "square.fill", helpText: "Match")
                    .onTapGesture {
                        store.page = 3
                        store.showMatchPanel = true
                    }
            }
        }
        .padding(.bottom, 2*8+12)
    }
}
