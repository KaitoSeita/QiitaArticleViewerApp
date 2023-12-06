//
//  PutMethodType.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/21.
//

import SwiftUI

protocol ArticleActionRequestType {
    var baseURL: URL? { get }
    var httpMethod: String { get }
    var relativePath: String { get }

    func buildURLRequest() -> URLRequest
}
