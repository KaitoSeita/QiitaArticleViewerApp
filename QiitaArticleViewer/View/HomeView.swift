//
//  HomeView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/05.
//

import RealmSwift
import SwiftUI

// Cookieが共有されないことがわかったので、認証と普通のログインで2回ログインしてもらうことになる
// articleがemptyだったら検索条件の変更を促す表示

struct HomeView: View {
    @EnvironmentObject var tabViewModel: TopTabViewModel
    
    @StateObject var viewModel = HomeViewModel()
    
    @State private var page = 1
    @State var isShowingSearchBar = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if viewModel.isShowingSearchBar {
                        Spacer().frame(height: 50)
                    }
                    ScrollViewReader { proxy in
                        List(viewModel.article) { article in
                            NavigationLink(destination: WebView(url: URL(string: article.url)!)
                                .onAppear {
                                    viewModel.onTapArticle(data: article)
                                }
                            ) {
                                ListItemView(title: article.title,
                                             user: article.user,
                                             likesCount: article.likesCount,
                                             createdDate: article.createdAt,
                                             viewCount: article.viewCount,
                                             tags: article.tags)
                                .onAppear {
                                    if viewModel.article.count > 7 {
                                        viewModel.onAppearEndOfList(id: article.id)
                                        viewModel.onAppearFirstOfList(id: article.id)
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        viewModel.onTapStockButton(id: article.articleId)
                                    } label: {
                                        Image(systemName: "folder.fill.badge.plus")
                                    }
                                }
                                .id(article.id)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                        .listStyle(.plain)
                        .refreshable {
                            viewModel.onRefresh()
                        }
                        .onAppear {
                            if viewModel.article.isEmpty {
                                viewModel.onRefresh()
                            }
                        }
                    }
                }
                Header(homeViewModel: viewModel)
                    .toast(isShowingErrorMessage: $viewModel.isShowingErrorMessage,
                           isShowingSuccessMessage: $viewModel.isShowingSuccessMessage,
                           errorMessage: viewModel.errorMessage,
                           successMessage: viewModel.successMessage)
            }
        }
    }
}

private struct Header: View {
    @EnvironmentObject var tabViewModel: TopTabViewModel
    
    @State private var isShowingAccountView = false
    @State private var isShowingSearchBar = false
    
    @Namespace var profile
    @Namespace var search
    
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        if isShowingSearchBar {
            SearchBar(isPresented: $isShowingSearchBar, search: search, homeViewModel: homeViewModel)
        } else if isShowingAccountView {
            AccountView(isPresented: $isShowingAccountView, profile: profile)
        } else {
            HStack {
                VStack {
                    SearchBar(isPresented: $isShowingSearchBar, search: search, homeViewModel: homeViewModel)
                    Spacer()
                }
                WidthSpacer(value: 10)
                VStack {
                    AccountView(isPresented: $isShowingAccountView, profile: profile)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
