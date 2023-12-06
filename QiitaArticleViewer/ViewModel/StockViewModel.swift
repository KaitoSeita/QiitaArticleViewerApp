//
//  StockViewModel.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI
import RealmSwift

// データベースの内容をリスト表示するだけのViewを作成　再利用できるように、データを受け渡せるようにしておく

protocol StockViewModelProtocol: ObservableObject {
    func onRefresh()
}

final class StockViewModel: StockViewModelProtocol {
    @Published var article: [ArticleList] = []
    @Published var errorMessage = ""
    @Published var isShowingErrorMessage = false
    @Published var currentPage = 1
    @Published var endOfList = false
    
    let apiService = APIService()
}

extension StockViewModel {
    
    func onRefresh() {
        Task { @MainActor in
            let request = StockedArticleRequest(page: "1")
            
            let result = await apiService.sendArticleRequest(request: request)
            switch result {
            case .success(let data):
                article.removeAll()
                for article in data {
                    self.article.append(
                        ArticleList(commentsCount: article.comments_count ?? 0,
                                    createdAt: dateFormatter(date: article.created_at!),
                                    likesCount: article.likes_count ?? 0,
                                    tags: article.tags,
                                    title: article.title,
                                    url: article.url,
                                    user: article.user,
                                    viewCount: article.page_views_count ?? 0,
                                    articleId: article.id ?? "")
                    )
                }
            case .failure(let error):
                print(error)
                setErrorMessage(error: error)
                isShowingErrorMessage = true
            }
        }
    }
    
    func onAppearEndOfList(id: UUID) {
        if article[article.endIndex - 6].id == id {
            currentPage += 1
            getNextArticles()
        }
    }
    
    func onAppearBottomOfList(id: UUID) {
        if article[article.endIndex - 1].id == id {
            endOfList = true
        } else if article[article.endIndex - 6].id == id{
            endOfList = false
        }
    }
    
    private func makeRealm(fileName: String) throws -> Realm {
        var config = Realm.Configuration()

        config.fileURL = try FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: false)
            .appendingPathComponent(fileName + ".realm")
        
        return try Realm(configuration: config)
    }
    
    private func getNextArticles() {
        Task { @MainActor in
            let request = StockedArticleRequest(page: String(currentPage))
            
            let result = await apiService.sendArticleRequest(request: request)
            
            switch result {
            case .success(let data):
                for article in data {
                    self.article.append(
                        ArticleList(commentsCount: article.comments_count ?? 0,
                                    createdAt: dateFormatter(date: article.created_at!),
                                    likesCount: article.likes_count ?? 0,
                                    tags: article.tags,
                                    title: article.title,
                                    url: article.url,
                                    user: article.user,
                                    viewCount: article.page_views_count ?? 0,
                                    articleId: article.id ?? "")
                    )
                }
            case .failure(let error):
                print(error)
                setErrorMessage(error: error)
                isShowingErrorMessage = true
            }
            
        }
    }
    
    func setDestination(id: String) -> AnyView? {
        if id == "ストック" {
            return AnyView(StockTopView())
        } else if id == "+" {
            return AnyView(MakeTabView())
        } else {
            return AnyView(Text("テスト"))
        }
    }
    
    private func dateFormatter(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60) // UTC+9時間
        let formatDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy年MM月dd日"
        
        return formatter.string(from: formatDate!)
    }

    private func setErrorMessage(error: Error) {
        if let error = error as? APIError {
            switch error {
            case .unowned:
                errorMessage = "不明なエラーです"
            case .networkTimeOut, .invalidStatusCode, .noData, .noResponse:
                errorMessage = "通信環境をご確認ください"
            case .decodingError:
                errorMessage = "再度お試しください"
            case .alreadyExisted:
                errorMessage = "すでに登録されています"
            case .authError:
                errorMessage = "ログインしてください"
            }
        }
    }
}
