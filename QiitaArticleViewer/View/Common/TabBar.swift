//
//  TabBar.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var tabViewModel: TopTabViewModel
    
    @Binding var selection: TabSelection
    
    let tabItems: [TabItems] = [TabItems(selection: .Home, tabItem: "house", tabName: "ホーム"),
                                TabItems(selection: .Stock, tabItem: "folder.fill", tabName: "ストック"),
                                TabItems(selection: .History, tabItem: "clock.arrow.circlepath", tabName: "履歴")]
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 45) {
                ForEach(tabItems) { item in
                    VStack {
                        HeightSpacer(value: 20)
                        Image(systemName: item.tabItem)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        HeightSpacer(value: 5)
                        Text(item.tabName)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                        HeightSpacer(value: 20)
                    }
                    .onTapGesture {
                        selection = item.selection
                        tabViewModel.isTappingTabItem = item.selection
                    }
                    .foregroundColor(item.selection == selection ? .green : .gray)
                }
            }
            .frame(width: 260, height: 70)
            .background(.ultraThinMaterial)
            .cornerRadius(25)
            HeightSpacer(value: 30)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
