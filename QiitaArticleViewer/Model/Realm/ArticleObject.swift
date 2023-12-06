//
//  ArticleObject.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/23.
//

import SwiftUI
import RealmSwift

class ArticleObject: Object, Identifiable {
    
    @Persisted var commentsCount: Int
    @Persisted var createdAt: String
    @Persisted var likesCount: Int
    @Persisted var tags: RealmSwift.List<TagsObject>
    @Persisted var title: String
    @Persisted var url: String
    @Persisted var user: UserObject?
    @Persisted var viewCount: Int
    @Persisted var articleId: String
    
    override static func primaryKey() -> String? {
        return "articleId"
    }
}

class TagsObject: Object {
    @Persisted var name: String
//    @Persisted var versions: RealmSwift.List<String>
}
