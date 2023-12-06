//
//  ArchiveView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

// 登録時のタイムスタンプを生成すること

struct ArchiveView: View {
    @EnvironmentObject var tabViewModel: TopTabViewModel

    @StateObject var viewModel = ArchiveViewModel()
        
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List(viewModel.article) { article in
                    NavigationLink(destination: WebView(url: URL(string: article.url)!)) {
                        ListItemView(title: article.title,
                                     user: article.user,
                                     likesCount: article.likesCount,
                                     createdDate: article.createdAt,
                                     viewCount: article.viewCount,
                                     tags: article.tags)
                        .onAppear {
                            viewModel.onAppearBottomOfList(id: article.id)

                            if viewModel.endOfList {
                                tabViewModel.isPresented = false
                            } else {
                                tabViewModel.isPresented = true
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                
                            } label: {
                                Image(systemName: "folder.fill.badge.plus")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    viewModel.onAppear()
                }
            }
        }
    }
}

#Preview {
    ArchiveView()
}
