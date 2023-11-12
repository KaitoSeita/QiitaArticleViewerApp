//
//  TabBar.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

struct TabBar: View {
    let tabIcon: [String] = ["house", "tag", "heart", "person.3.fill"]
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 90)
                .foregroundColor(.gray)
                .overlay {
                    HStack(spacing: 60) {
                        
                    }
                }
        }.ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    TabBar()
}
