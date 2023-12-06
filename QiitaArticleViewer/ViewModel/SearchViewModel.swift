//
//  SearchViewModel.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/27.
//

import SwiftUI
import RealmSwift

final class SearchViewModel: ObservableObject {
    @Published var word: [String] = []
}

extension SearchViewModel {
    
    func onAppear() {
        do {
            let realm = try Realm()
            let result = realm.objects(SearchArchiveObject.self)
            let wordList = Array(result).reversed()
            
            for word in wordList {
                self.word.append(word.text)
            }
            
            print("successed!")
        } catch {
            print(error)
        }
    }
    
    func onTapSearchButton(text: String) {
        do {
            let realm = try Realm()
            try realm.write {
                let searchObject = SearchArchiveObject()
                searchObject.text = text
                realm.add(searchObject, update:.modified)
            }
            print("Data added successfully.")
        } catch {
            print("Error adding data to MyRealm: \(error)")
        }
    }
}
