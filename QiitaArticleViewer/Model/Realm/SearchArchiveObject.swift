//
//  SearchArchiveObject.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/27.
//

import SwiftUI
import RealmSwift

class SearchArchiveObject: Object, Identifiable {
    @Persisted var text: String
    
    override static func primaryKey() -> String? {
        return "text"
    }
}
