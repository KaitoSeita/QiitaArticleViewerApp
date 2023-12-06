//
//  APIRequestType.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/06.
//

import SwiftUI

protocol ArticleRequestType {
    associatedtype Response: Codable
    
    var baseURL: URL? { get }
    var httpMethod: String { get }
    var relativePath: String { get }

    func buildURLRequest() -> URLRequest
}
