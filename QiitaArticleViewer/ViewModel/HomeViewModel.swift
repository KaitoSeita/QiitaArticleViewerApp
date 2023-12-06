//
//  HomeViewModel.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/05.
//

import SwiftUI
import RealmSwift

protocol HomeViewModelProtocol: ObservableObject {
    func onRefresh()
    func onAppearEndOfList(id: UUID)
    func onTapStockButton(id: String?)
}

final class HomeViewModel: HomeViewModelProtocol {
    @Published var article: [ArticleList] = []
    @Published var isShowingErrorMessage = false
    @Published var isShowingSuccessMessage = false
    @Published var isShowingSearchBar = false
    @Published var errorMessage = ""
    @Published var successMessage = ""
    @Published var currentPage = 1
    @Published var text = ""
    @Published var searchSelection: SearchSelection = .title
    @Published var articleid = UUID()
    
    let apiService = APIService()
}

extension HomeViewModel {
        
    func onRefresh() {
        Task { @MainActor in
            let request = SearchArticleRequest(page: "1", text: text, selection: searchSelection)
            
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
        
    func onTapTabBar(id: UUID) {
        if article[article.startIndex].id == id {
            articleid = id
        }
    }
    
    func onAppearFirstOfList(id: UUID) {
        if article[article.startIndex].id == id {
            withAnimation(.easeInOut(duration: 0.3)) {
                isShowingSearchBar = true
            }
        } else if article[article.startIndex + 5].id == id {
            withAnimation(.easeInOut(duration: 0.3)) {
                isShowingSearchBar = false
            }
        }
    }
    
    // 記事が5個以上ない場合にクラッシュ
    func onAppearEndOfList(id: UUID) {
        if article[article.endIndex - 5].id == id {
            currentPage += 1
            getNextArticles()
        }
    }
    
    func onTapStockButton(id: String?) {
        Task { @MainActor in
            let request = ArticleActionRequest(itemid: id!, action: "stock", method: "GET")
            let result = await apiService.sendArticleActionRequest(request: request)
            switch result {
            case .success(let isStocked):
                if isStocked == .done {
                    setErrorMessage(error: APIError.alreadyExisted)
                    isShowingErrorMessage = true
                } else {
                    makeStock(id: id)
                }
            case .failure(let error):
                print(error)
                setErrorMessage(error: error)
                isShowingErrorMessage = true
            }
        }
    }
    
    func onTapArticle(data: ArticleList) {
        do {
            let realm = try Realm()
            try realm.write {
                let articleObject = ArticleObject()
                let userObject = UserObject()
                            
                for i in 0 ..< data.tags.count {
                    let tagsObject = TagsObject()
                    tagsObject.name = data.tags[i].name
                    
                    articleObject.tags.append(tagsObject)
                }
                
                userObject.descriptionText = data.user.description ?? ""
                userObject.facebookID = data.user.facebook_id ?? ""
                userObject.followeesCount = data.user.followees_count ?? 0
                userObject.followersCount = data.user.followers_count ?? 0
                userObject.githubLoginName = data.user.github_login_name ?? ""
                userObject.userID = data.user.id ?? ""
                userObject.itemsCount = data.user.items_count ?? 0
                userObject.linkedinID = data.user.linkedin_id ?? ""
                userObject.location = data.user.location ?? ""
                userObject.name = data.user.name ?? ""
                userObject.organization = data.user.oganization ?? ""
                userObject.parmanentID = data.user.parmanent_id ?? ""
                userObject.profileImageURL = data.user.profile_image_url ?? ""
                userObject.teamOnly = data.user.team_only
                userObject.twitterScreenName = data.user.twitter_screen_name ?? ""
                userObject.websiteURL = data.user.website_url ?? ""
                
                articleObject.user = userObject
                
                articleObject.commentsCount = data.commentsCount
                articleObject.createdAt = data.createdAt
                articleObject.likesCount = data.likesCount
                articleObject.title = data.title
                articleObject.url = data.url
                articleObject.viewCount = data.viewCount
                articleObject.articleId = data.articleId
                
                realm.add(articleObject, update:.modified)
            }
            
            print("Data added successfully.")
        } catch {
            print("Error adding data to MyRealm: \(error)")
        }
    }
    
//    private func makeRealm(fileName: String) throws -> Realm {
//        var config = Realm.Configuration()
//
//        config.fileURL = try! FileManager.default.url(for: .documentDirectory,
//                                                      in: .userDomainMask,
//                                                      appropriateFor: nil,
//                                                      create: false)
//            .appendingPathComponent(fileName + ".realm")
//        
//        return try! Realm(configuration: config)
//    }
    
    private func getNextArticles() {
        Task { @MainActor in
            let request = SearchArticleRequest(page: String(currentPage), text: text, selection: searchSelection)
            
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
    
    private func makeStock(id: String?) {
        Task { @MainActor in
            let request = ArticleActionRequest(itemid: id!, action: "stock", method: "PUT")
            let result = await apiService.sendArticleActionRequest(request: request)
            switch result {
            case .success(let isStocked):
                if isStocked == .done {
                    successMessage = "ストックしました"
                    isShowingSuccessMessage = true
                }
            case .failure(let error):
                print(error)
                setErrorMessage(error: error)
                isShowingErrorMessage = true
            }
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
