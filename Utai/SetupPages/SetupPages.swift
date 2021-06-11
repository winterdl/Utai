//
//  SetupPages.swift
//  Utai
//
//  Created by Toto Minai on 2021/06/11.
//

import SwiftUI

struct SetupPages: View {
    @Binding var page: Int
    
    var body: some View {
        HStack(spacing: 0) {
            SetupPage1(page: $page)
        }
        .offset(x: CGFloat(1 - page) * unitLength)
        .frame(width: unitLength, alignment: .leading)
        .clipped()
    }
}

struct ReferencesControl: View {
    @Binding var page: Int
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                ControlButton(systemName: "book")
                    .padding(8)
            }
            
            Spacer()
        }
    }
}
