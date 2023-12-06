//
//  AccountView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

// ログイン, ログアウト処理の通知を送信すること

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var tabViewModel: TopTabViewModel

    @StateObject var oauth = APIOAuth()
    @StateObject var viewModel = AccountViewModel()
    
    @Binding var isPresented: Bool
    
    var profile: Namespace.ID
    
    var body: some View {
        if isPresented {
            ProfileView(isPresented: $isPresented,
                        oauth: oauth,
                        profileImageURL: viewModel.user.profileImageURL,
                        userid: viewModel.user.userId,
                        name: viewModel.user.name,
                        itemsCount: viewModel.user.itemsCount,
                        followeesCount: viewModel.user.followeesCount,
                        followersCount: viewModel.user.followersCount)
            .matchedGeometryEffect(id: "profile", in: profile)
            .ignoresSafeArea()
            .onAppear {
                if viewModel.user.userId.isEmpty {
                    viewModel.onRefresh()
                }
                tabViewModel.isPresented = false
            }
        } else {
            AsyncImage(url: URL(string: viewModel.user.profileImageURL)) { image in
                image
                    .resizable()
                    .clipShape(Circle())
                    .matchedGeometryEffect(id: "profile", in: profile)
                    .frame(width: 45, height:45)
            } placeholder: {
                Circle()
                    .foregroundColor(.black.opacity(0.85))
                    .matchedGeometryEffect(id: "profile", in: profile)
                    .frame(width: 45, height:45)
                    .overlay {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                    }
            }
            .onAppear {
                if viewModel.user.userId.isEmpty {
                    viewModel.onRefresh()
                }
                tabViewModel.isPresented = true
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPresented = true
                }
            }
        }
    }
}

private struct ProfileView: View {
    @Binding var isPresented: Bool
        
    @ObservedObject var oauth: APIOAuth
    
    let profileImageURL: String
    let userid: String
    let name: String
    let itemsCount: Int
    let followeesCount: Int
    let followersCount: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundColor(.black.opacity(0.95))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                VStack {
                    HeightSpacer(value: 60)
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
                    HeightSpacer(value: 20)
                    if KeyChain().read(service: "com.shonbeno.QiitaArticleViewer", key: "accessToken") != nil {
                        AsyncImage(url: URL(string: profileImageURL)) { image in
                            image
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 70, height:70)
                        } placeholder: {
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 70, height:70)
                        }
                        HeightSpacer(value: 20)
                        Text(name)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .bold()
                            .lineLimit(2)
                        Text("@\(userid)")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        HeightSpacer(value: 30)
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(itemsCount)")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                HeightSpacer(value: 10)
                                Text("投稿")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 80, height: 40)
                            VStack {
                                Text("\(followeesCount)")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                HeightSpacer(value: 10)
                                Text("フォロー")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 80, height: 40)
                            VStack {
                                Text("\(followersCount)")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                HeightSpacer(value: 10)
                                Text("フォロワー")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 80, height: 40)
                        }
                        HeightSpacer(value: 20)
                        SettingsList()
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 300, height: 40)
                            .foregroundColor(.red)
                            .overlay {
                                Text("ログアウト")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .fontWeight(.heavy)
                            }
                            .onTapGesture {
                                KeyChain().delete(service: "com.shonbeno.QiitaArticleViewer", key: "accessToken")
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isPresented = false
                                }
                            }
                        HeightSpacer(value: 50)
                    } else {
                        SettingsList()
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 300, height: 40)
                            .foregroundColor(.white)
                            .overlay {
                                Text("ログイン")
                                    .foregroundColor(.black)
                                    .font(.caption)
                                    .fontWeight(.heavy)
                            }
                            .onTapGesture {
                                oauth.loginSession()
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isPresented = false
                                }
                            }
                        HeightSpacer(value: 50)
                    }
                }
            }
    }
}

private struct SettingsList: View {
    var body: some View {
        VStack {
            
        }
    }
}
