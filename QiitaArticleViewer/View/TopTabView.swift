//
//  TopTabView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

// タブの各ボタンをタップしたら更新ではないが、スクロールを一番上まで持っていく

struct TopTabView: View {
    @StateObject var viewModel = TopTabViewModel()
    @State private var selection: TabSelection = .Home
    
    let tabItems: [TabItems] = [TabItems(selection: .Home, tabItem: "house", tabName: "ホーム"),
                                TabItems(selection: .Stock, tabItem: "folder.fill", tabName: "ストック"),
                                TabItems(selection: .History, tabItem: "clock.arrow.circlepath", tabName: "履歴")]
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                ForEach(tabItems) { item in
                    viewModel.setDestination(selection: item.selection)
                        .tag(item.selection)
                }
            }
            if viewModel.isPresented {
                TabBar(selection: $selection)                
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    TopTabView()
}
