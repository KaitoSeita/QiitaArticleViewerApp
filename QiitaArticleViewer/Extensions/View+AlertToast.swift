//
//  View+AlertToast.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/10/16.
//

import SwiftUI
import AlertToast

// extensionでアラートトーストに表示終了後にisStockedをfalseにできるようにしたい

struct Toast: ViewModifier {
    @Binding var isShowingErrorMessage: Bool
    @Binding var isShowingSuccessMessage: Bool
    
    let errorMessage: String
    let successMessage: String
    
    func body(content: Content) -> some View {
        content
            .toast(isPresenting: $isShowingErrorMessage, alert: {
                AlertToast(displayMode: .hud ,
                           type: .systemImage("exclamationmark.triangle", .red.opacity(0.5)),
                           subTitle: errorMessage)
            })
            .toast(isPresenting: $isShowingSuccessMessage, alert: {
                AlertToast(displayMode: .hud ,
                           type: .systemImage("checkmark.circle", .green.opacity(0.5)),
                           subTitle: successMessage)
            })
    }
}

extension View {
    
    func toast(isShowingErrorMessage: Binding<Bool>, isShowingSuccessMessage: Binding<Bool>, errorMessage: String, successMessage: String) -> some View {
        self.modifier(Toast(isShowingErrorMessage: isShowingErrorMessage,
                            isShowingSuccessMessage: isShowingSuccessMessage,
                            errorMessage: errorMessage,
                            successMessage: successMessage))
    }
}

