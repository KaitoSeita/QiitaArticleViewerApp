//
//  SearchView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/25.
//


import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var tabViewModel: TopTabViewModel

    @Binding var isPresented: Bool
    
    @State private var text = ""
    @State private var isSelectedToggle: SearchSelection = .title
    
    var search: Namespace.ID
    
    @ObservedObject var homeViewModel: HomeViewModel
    @StateObject var searchViewModel = SearchViewModel()

    var body: some View {
        if isPresented {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.black.opacity(0.95))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    VStack {
                        HeightSpacer(value: 60)
                        CancelButton(isPresented: $isPresented)
                        HeightSpacer(value: 30)
                        SelectToggle(isSelected: $isSelectedToggle)
                        HeightSpacer(value: 10)
                        SearchForm(text: $text)
                        HeightSpacer(value: 20)
                        SearchArchive(viewModel: searchViewModel, text: $text)
                        HeightSpacer(value: 30)
                        SearchButton(homeViewModel: homeViewModel,
                                     searchViewModel: searchViewModel,
                                     isPresented: $isPresented,
                                     text: text,
                                     selection: isSelectedToggle)
                        Spacer()
                    }
                }
                .matchedGeometryEffect(id: "search", in: search)
                .ignoresSafeArea()
                .onAppear {
                    tabViewModel.isPresented = false
                }
        } else {
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(.black.opacity(0.85))
                .frame(width: 250, height: 45)
                .matchedGeometryEffect(id: "search", in: search)
                .grayShadow()
                .overlay {
                    HStack {
                        if homeViewModel.text.isEmpty {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 60, height: 25)
                                .foregroundColor(.white.opacity(0.22))
                                .overlay {
                                    Text(homeViewModel.searchSelection.rawValue)
                                        .foregroundColor(.white)
                                        .font(.system(size: 10))
                                        .fontWeight(.bold)
                                }
                                .padding(.horizontal, 10)
                            Text(homeViewModel.text)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 17, height: 17)
                                .foregroundColor(.white)
                                .padding(.trailing, 15)
                                .onTapGesture {
                                    homeViewModel.text = ""
                                    homeViewModel.onRefresh()
                                }
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPresented = true
                    }
                }
                .onAppear {
                    tabViewModel.isPresented = true
                }
        }
    }
}

private struct CancelButton: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(.trailing, 30)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPresented = false
                    }
                }
        }
    }
}

private struct SelectToggle: View{
    @Binding var isSelected: SearchSelection
    
    @Namespace var selectToggle
    
    private let toggleItem = [SearchSelection.title,
                              SearchSelection.code,
                              SearchSelection.user,
                              SearchSelection.tag]
    private let columns: [GridItem] = Array(repeating: GridItem(.fixed(70)), count: 4)
        
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 330, height: 40)
            .foregroundColor(.black)
            .overlay{
                LazyVGrid(columns: columns, alignment: .center, spacing: 15){
                    ForEach(toggleItem, id: \.self){ item in
                        ZStack{
                            Text(item.rawValue)
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(.white)
                                .bold()
                                .onTapGesture{
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)){
                                        self.isSelected = item
                                    }
                                }
                            if isSelected.rawValue == item.rawValue {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 80, height: 30)
                                    .foregroundColor(.white.opacity(0.22))
                                    .matchedGeometryEffect(id: "SelectToggle", in: selectToggle)
                            }
                        }
                    }
                }
            }
    }
}

// TODO: ソートオプション
//private struct SearchSortOption: View {
//    let text: String
//    
//    var body: some View {
//        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
//    }
//}

private struct SearchForm: View {
    @Binding var text: String
    
    var body: some View {
        TextField("入力してください", text: $text)
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .autocapitalization(.none)
            .padding(.leading, 50)
    }
}

private struct SearchArchive: View {
    @ObservedObject var viewModel: SearchViewModel
    
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.white)
                    .bold()
                Text("検索履歴")
                    .foregroundColor(.white)
                    .font(.caption)
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding(.leading, 50)
            HeightSpacer(value: 15)
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.word, id: \.self) { word in
                        HStack {
                            Text(word)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.heavy)
                                .padding(.leading, 10)
                                .onTapGesture {
                                    text = word
                                }
                            Spacer()
                        }
                        HeightSpacer(value: 20)
                    }
                }
                .background(Color.clear)
            }
            .frame(width: 300, height: 200)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private struct SearchButton: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var searchViewModel: SearchViewModel
    
    @Binding var isPresented: Bool
    
    let text: String
    let selection: SearchSelection
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 300, height: 40)
            .foregroundColor(.white)
            .overlay {
                Text("検索")
                    .foregroundColor(.black)
                    .font(.caption)
                    .fontWeight(.heavy)
            }
            .onTapGesture {
                if !text.isEmpty {
                    searchViewModel.onTapSearchButton(text: text)
                }
                homeViewModel.text = self.text
                homeViewModel.searchSelection = self.selection
                homeViewModel.onRefresh()
                isPresented = false
            }
    }
}
