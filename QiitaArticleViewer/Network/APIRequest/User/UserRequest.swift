//
//  UserRequest.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/22.
//

import SwiftUI

struct UserRequest: UserRequestType {
    let url: URL? = URL(string: "https://qiita.com/api/v2/authenticated_user")!
    let httpMethod = "GET"
    
    func buildURLRequest() -> URLRequest {
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
    
        var request = URLRequest(url: url!)
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
