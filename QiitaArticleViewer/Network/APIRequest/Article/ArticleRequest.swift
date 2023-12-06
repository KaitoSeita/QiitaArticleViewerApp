//
//  ArticleWithTagRequest.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/21.
//

import SwiftUI

// 全部に対応するように場合わけ

struct ArticleRequest: ArticleRequestType {
    typealias Response = [Article]
        
    let baseURL: URL? = URL(string: "https://qiita.com/api/v2")!
    let httpMethod: String = "GET"
    var relativePath: String = ""
    let page: String
    
    init(query: String, selection: ArticleSelection, page: String) {
        self.page = page
        switch selection {
        case .latest:
            relativePath += "/items"
        case .tags:
            relativePath += "/tags/\(query)/items"
        case .users:
            relativePath += ""
        }
    }
    
    func buildURLRequest() -> URLRequest {
        let url = baseURL!.appendingPathComponent(relativePath)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "per_page", value: "15")
        ]
        
        var request = URLRequest(url: url)
        request.url = components?.url
        request.httpMethod = httpMethod
        request.timeoutInterval = 5
        // トークンが存在しなければヘッダーに付与せず通常の呼び出しにする
        if let token = KeyChain().read(service: "com.shonbeno.QiitaArticleViewer", key: "accessToken") {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.allHTTPHeaderFields = ["Authorization": "Bearer \(token)"]
        }
        return request
    }
}
