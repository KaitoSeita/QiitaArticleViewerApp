//
//  WebView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/06.
//

import SwiftUI
import WebKit

struct WebView: View {
    let url: URL
    
    @EnvironmentObject var tabViewModel: TopTabViewModel

    var body: some View {
        ZStack {
            WKWebViewController(url: url)
                .ignoresSafeArea(edges: .bottom)
            Color.clear
                .customBackwardButton()
        }
        .onAppear {
            withAnimation(.linear) {
                tabViewModel.isPresented = false
            }
        }
        .onDisappear {
            withAnimation(.linear) {
                tabViewModel.isPresented = true
            }
        }
    }
}

private struct WKWebViewController: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
