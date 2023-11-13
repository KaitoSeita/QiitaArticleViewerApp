//
//  View+Spacer.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/09/25.
//

import SwiftUI

extension View {
    
    func HeightSpacer(value: CGFloat) -> some View {
        Spacer()
            .frame(height: value)
    }
    
    func WidthSpacer(value: CGFloat) -> some View {
        Spacer()
            .frame(width: value)
    }
}
