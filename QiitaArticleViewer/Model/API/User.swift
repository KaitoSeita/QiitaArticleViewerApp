//
//  User.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/06.
//

import SwiftUI

struct User: Codable {
    let description: String?
    let facebook_id: String?
    let followees_count: Int?
    let followers_count: Int?
    let github_login_name: String?
    let id: String?
    let items_count: Int?
    let linkedin_id: String?
    let location: String?
    let name: String?
    let oganization: String?
    let parmanent_id: String?
    let profile_image_url: String?
    let team_only: Bool
    let twitter_screen_name: String?
    let website_url: String?
}

struct UserInfomation: Identifiable {
    let id = UUID()
    let description: String
    let facebook_id: String
    let followeesCount: Int
    let followersCount: Int
    let githubLoginName: String
    let userId: String
    let itemsCount: Int
    let location: String
    let name: String
    let oganization: String
    let profileImageURL: String
    let twitterScreenName: String
    let websiteURL: String
}
