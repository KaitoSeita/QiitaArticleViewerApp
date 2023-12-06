//
//  SearchArticleRequest.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/25.
//

import SwiftUI

struct SearchArticleRequest: ArticleRequestType {
    typealias Response = [Article]
        
    let baseURL: URL? = URL(string: "https://qiita.com/api/v2/")!
    let httpMethod: String = "GET"
    var relativePath: String = ""
    let page: String
    let text: String
    let selection: SearchSelection
    
    init(page: String, text: String, selection: SearchSelection) {
        self.page = page
        self.text = text
        self.selection = selection
        if text != "" {
            switch self.selection {
            case .title, .code, .user:
                relativePath = "items"
            case .tag:
                relativePath = "tags/\(text)/items"
            }
        } else {
            relativePath = "items"
        }
    }
    
    func buildURLRequest() -> URLRequest {
        let url = baseURL!.appendingPathComponent(relativePath)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "per_page", value: "15")
        ]
        
        if text != "" {
            switch selection {
            case .title:
                components?.queryItems?.append(URLQueryItem(name: "query", value: "title:\(text)"))
            case .code:
                components?.queryItems?.append(URLQueryItem(name: "query", value: "code:\(text)"))
            case .user:
                components?.queryItems?.append(URLQueryItem(name: "query", value: "user:\(text)"))
            case .tag:
                print("tags")
            }
        }
        
        // https://qiita.com/api/v2/items?q=swift&sort=stock ソートできる
        // Stringで構成しないといけない クエリアイテムからはできない
        // 関連順とかいろいろ選択できるように!
        
        var request = URLRequest(url: url)
        request.url = components?.url
        
        print(request.url!)
        
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
