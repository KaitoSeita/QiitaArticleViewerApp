//
//  TopTabView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

struct TopTabView: View {
    @StateObject var viewModel = TopTabViewModel()
    @State private var selection: TabSelection = .Home
    
    var body: some View {
        ZStack {
            viewModel.setDestination(selection: selection)
            if viewModel.isPresented {
                TabBar(selection: $selection)
                    .transition(.move(edge: .bottom))
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    TopTabView()
}
