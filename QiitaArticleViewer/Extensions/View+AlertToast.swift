//
//  View+AlertToast.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/10/16.
//

import SwiftUI
import AlertToast

struct Toast: ViewModifier {
    @Binding var isShowingErrorMessage: Bool
    @Binding var isShowingLoadingToast: Bool
    
    let errorMessage: String
    
    func body(content: Content) -> some View {
        content
            .toast(isPresenting: $isShowingErrorMessage, alert: {
                AlertToast(displayMode: .hud ,
                           type: .systemImage("xmark", .red.opacity(0.5)),
                           subTitle:  errorMessage)
            })
            .toast(isPresenting: $isShowingLoadingToast, alert: {
                AlertToast(type: .loading)
            })
    }
}

extension View {
    
    func toast(isShowingErrorMessage: Binding<Bool>, isShowingLoadingToast: Binding<Bool>, errorMessage: String) -> some View {
        self.modifier(Toast(isShowingErrorMessage: isShowingErrorMessage, isShowingLoadingToast: isShowingLoadingToast, errorMessage: errorMessage))
    }
}
