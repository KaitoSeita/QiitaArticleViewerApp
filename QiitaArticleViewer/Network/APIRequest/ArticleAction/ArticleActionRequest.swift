//
//  APIRequestPutMethod.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/21.
//

import SwiftUI

// GetArticleStatus

struct ArticleActionRequest: ArticleActionRequestType {

    let baseURL: URL? = URL(string: "https://qiita.com/api/v2/items")!
    let httpMethod: String
    var relativePath: String = ""
    
    init(itemid: String, action: String, method: String) {
        self.httpMethod = method
        relativePath += "/\(itemid)/\(action)"
    }
    
    func buildURLRequest() -> URLRequest {
        let url = baseURL!.appendingPathComponent(relativePath)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    
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
