//
//  StockView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

struct StockView: View {
    @StateObject var viewModel = StockViewModel()

    var body: some View {

        StockTopView()
    }
}

// 検索バーの追加
// 取得したviewmodelのarticleに対して、文字列やタグに関するものを検索かけられるように

struct MakeTabView: View {
    @State private var text = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HeightSpacer(value: 50)
                Text("追加するフォルダの名前を\n入力してください")
                    .font(.title2)
                    .bold()
                TextField("フォルダ名", text: $text)
                    .font(.title)
                    .fontWeight(.heavy)
                    .autocapitalization(.none)
            }
            HeightSpacer(value: 50)
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300, height: 55)
                .foregroundColor(.black)
                .overlay {
                    Text("追加する")
                        .font(.system(size: 19, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                }
            Spacer()
        }
        .padding(.horizontal, 50)
    }
}

struct StockTopView: View {
    @EnvironmentObject var tabViewModel: TopTabViewModel
    
    @StateObject var viewModel = StockViewModel()

    var body: some View {
        VStack {
            Spacer().frame(height: 50)
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
                                viewModel.onAppearEndOfList(id: article.id)
                                viewModel.onAppearBottomOfList(id: article.id)
                                
                                if viewModel.endOfList {
                                    tabViewModel.isPresented = false
                                } else {
                                    tabViewModel.isPresented = true
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        withAnimation(.linear) {
                            viewModel.onRefresh()
                        }
                    }
                    .onAppear {
                        if viewModel.article.isEmpty {
                            viewModel.onRefresh()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StockView()
}
