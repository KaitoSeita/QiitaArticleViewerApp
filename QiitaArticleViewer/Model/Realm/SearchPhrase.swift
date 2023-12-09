//
//  SearchPhrase.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/12/07.
//

import SwiftUI
import RealmSwift

class SearchPhrase: Object, Identifiable {
    @Persisted var text: String
    
    override static func primaryKey() -> String? {
        return "text"
    }
}
