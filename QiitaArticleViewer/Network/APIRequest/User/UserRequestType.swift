//
//  UserRequestType.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/22.
//

import SwiftUI

protocol UserRequestType {
    var url: URL? { get }
    var httpMethod: String { get }

    func buildURLRequest() -> URLRequest
}
