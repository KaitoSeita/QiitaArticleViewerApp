//
//  TabBar.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

struct TabBar: View {
    @Binding var selection: TabSelection
    
    let tabItems: [TabItems] = [TabItems(selection: .Home, tabItem: "house", tabName: "ホーム"),
                                TabItems(selection: .Stock, tabItem: "folder.fill", tabName: "ストック"),
                                TabItems(selection: .Likes, tabItem: "heart", tabName: "いいね"),
                                TabItems(selection: .Account, tabItem: "person.fill", tabName: "アカウント")]
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 55) {
                ForEach(tabItems) { item in
                    VStack {
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
                        withAnimation(.linear) {
                            selection = item.selection
                        }
                    }
                    .foregroundColor(item.selection == selection ? .green : .gray)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 90)
            .background(.ultraThinMaterial)
            .cornerRadius(17)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
