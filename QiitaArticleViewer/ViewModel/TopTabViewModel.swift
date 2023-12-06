//
//  TopTabViewModel.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

protocol TopTabViewModelProtocol: ObservableObject {
    func setDestination(selection: TabSelection) -> AnyView?
    func onDisappear()
    func onAppear()
}

final class TopTabViewModel: TopTabViewModelProtocol {
    @Published var isPresented = true
    @Published var isTappingTabItem: TabSelection = .Default
}

extension TopTabViewModel {
    
    func onDisappear() {
        isPresented = false
    }
    
    func onAppear() {
        isPresented = true
    }
    
    func setDestination(selection: TabSelection) -> AnyView? {
        switch selection {
        case .Home:
            return AnyView(HomeView())
        case .Stock:
            return AnyView(StockView())
        case .History:
            return AnyView(ArchiveView())
        case .Default:
            return AnyView(EmptyView())
        }
    }
}
