//
//  View+Spacer.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/09/25.
//

import SwiftUI

extension View {
    
    func HeightSpacer(height: CGFloat) -> some View {
        Spacer()
            .frame(height: height)
    }
    
    func WidthSpacer(width: CGFloat) -> some View {
        Spacer()
            .frame(width: width)
    }
}
