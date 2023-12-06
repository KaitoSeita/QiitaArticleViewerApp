//
//  View+Shadow.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/09/27.
//

import SwiftUI

struct GrayShadow: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .shadow(color: .white.opacity(0.8), radius: 10, x: -7, y: -7)
            .shadow(color: .gray.opacity(0.3), radius: 10, x: 8, y: 8)
    }
}

extension View {
    
    func grayShadow() -> some View {
        self.modifier(GrayShadow())
    }
}
