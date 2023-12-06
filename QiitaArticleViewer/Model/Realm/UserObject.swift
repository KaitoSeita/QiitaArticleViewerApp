//
//  UserObject.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/22.
//

import SwiftUI
import RealmSwift

class UserObject: Object {
    @Persisted var descriptionText: String
    @Persisted var facebookID: String
    @Persisted var followeesCount: Int
    @Persisted var followersCount: Int
    @Persisted var githubLoginName: String
    @Persisted var userID: String
    @Persisted var itemsCount: Int
    @Persisted var linkedinID: String
    @Persisted var location: String
    @Persisted var name: String
    @Persisted var organization: String
    @Persisted var parmanentID: String
    @Persisted var profileImageURL: String
    @Persisted var teamOnly: Bool
    @Persisted var twitterScreenName: String
    @Persisted var websiteURL: String
}

