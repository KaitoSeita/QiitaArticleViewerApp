//
//  ArchiveViewModel.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI
import RealmSwift

protocol ArchiveViewModelProtocol: ObservableObject {
    
}

final class ArchiveViewModel: ArchiveViewModelProtocol {
    @Published var article: [ArticleList] = []
    @Published var isShowingErrorMessage = false
    @Published var isShowingSuccessMessage = false
    @Published var errorMessage = ""
    @Published var successMessage = ""
    @Published var endOfList = false

}

extension ArchiveViewModel {
    
    func onAppear() {
        do {
            let realm = try Realm()
            let result = realm.objects(ArticleObject.self)
            let articleList = Array(result).reversed()
            
            var tags: [Tags] = []
            
            article.removeAll()
            
            for article in articleList {
                
                for i in 0 ..< article.tags.count {
                    tags.append(Tags(name: article.tags[i].name, versions: [""]))
                }
                
                let user = User(description: article.user?.descriptionText,
                                facebook_id: article.user?.facebookID,
                                followees_count: article.user?.followeesCount,
                                followers_count: article.user?.followersCount,
                                github_login_name: article.user?.githubLoginName,
                                id: article.user?.userID,
                                items_count: article.user?.itemsCount,
                                linkedin_id: article.user?.linkedinID,
                                location: article.user?.location,
                                name: article.user?.name,
                                oganization: article.user?.organization,
                                parmanent_id: article.user?.parmanentID,
                                profile_image_url: article.user?.profileImageURL,
                                team_only: article.user?.teamOnly ?? false,
                                twitter_screen_name: article.user?.twitterScreenName,
                                website_url: article.user?.websiteURL)
                
                self.article.append(
                    ArticleList(commentsCount: article.commentsCount,
                                createdAt: article.createdAt,
                                likesCount: article.likesCount,
                                tags: tags,
                                title: article.title,
                                url: article.url,
                                user: user,
                                viewCount: article.viewCount,
                                articleId: article.articleId)
                )
                
                tags.removeAll()
            }
        } catch {
            print(error)
        }
    }
    
    func onAppearBottomOfList(id: UUID) {
        if article[article.endIndex - 1].id == id {
            endOfList = true
        } else if article[article.endIndex - 6].id == id{
            endOfList = false
        }
    }
    
    private func dateFormatter(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60) // UTC+9時間
        let formatDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy年MM月dd日"
        
        return formatter.string(from: formatDate ?? Date())
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
