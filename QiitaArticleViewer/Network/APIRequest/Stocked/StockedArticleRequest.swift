//
//  StockedArticleRequest.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/22.
//

import SwiftUI

struct StockedArticleRequest: ArticleRequestType {
    typealias Response = [Article]
        
    let baseURL: URL? = URL(string: "https://qiita.com/api/v2/users")!
    let httpMethod: String = "GET"
    var relativePath: String = ""
    let page: String
    let userid = String(KeyChain().read(service: "com.shonbeno.QiitaArticleViewer", key: "userid") ?? "")
    
    init(page: String) {
        self.page = page
        relativePath += "/\(userid)/stocks"
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
