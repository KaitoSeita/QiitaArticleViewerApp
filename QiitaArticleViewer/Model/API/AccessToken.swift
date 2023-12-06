//
//  AccessToken.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/20.
//

struct AccessToken: Codable {
    var client_id: String?
    var scopes: [String]
    var token: String?
}
