//
//  AccountViewModel.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

final class AccountViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var isShowingErrorMessage = false
    @Published var user = UserInfomation(description: "",
                                         facebook_id: "",
                                         followeesCount: 0,
                                         followersCount: 0,
                                         githubLoginName: "",
                                         userId: "",
                                         itemsCount: 0,
                                         location: "",
                                         name: "",
                                         oganization: "",
                                         profileImageURL: "",
                                         twitterScreenName: "",
                                         websiteURL: "")
    
    let apiService = APIService()
    
}

extension AccountViewModel {
    
    func onRefresh() {
        Task { @MainActor in
            let request = UserRequest()
            
            let result = await apiService.sendUserRequest(request: request)
            switch result {
            case .success(let data):
                user = UserInfomation(description: data.description ?? "",
                                      facebook_id: data.facebook_id ?? "",
                                      followeesCount: data.followees_count ?? 0,
                                      followersCount: data.followers_count ?? 0,
                                      githubLoginName: data.github_login_name ?? "",
                                      userId: data.id ?? "",
                                      itemsCount: data.items_count ?? 0,
                                      location: data.location ?? "",
                                      name: data.name ?? "",
                                      oganization: data.oganization ?? "",
                                      profileImageURL: data.profile_image_url ?? "",
                                      twitterScreenName: data.twitter_screen_name ?? "",
                                      websiteURL: data.website_url ?? "")
                if let userid = data.id!.data(using: .utf8) {
                    KeyChain().save(userid, service: "com.shonbeno.QiitaArticleViewer", key: "userid")
                } else {
                    print("Failed to convert token to data.")
                }
                
            case .failure(let error):
                print(error)
                setErrorMessage(error: error)
                isShowingErrorMessage = true
            }
        }
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
                errorMessage = "認証に失敗しました"
            }
        }
    }
}
