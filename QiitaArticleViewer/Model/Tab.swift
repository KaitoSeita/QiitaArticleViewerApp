//
//  Tab.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

struct TabItems: Identifiable, Hashable {
    var id = UUID()
    var selection: TabSelection
    var tabItem: String
    var tabName: String
}

enum TabSelection {
    case Home
    case Stock
    case History
    case Default
}

// ストック GET /api/v2/users/:user_id/stocks
