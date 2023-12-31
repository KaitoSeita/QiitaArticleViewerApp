//
//  ListItemView.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/22.
//

import SwiftUI

struct ListItemView: View {
    let title: String?
    let user: User
    let likesCount: Int?
    let createdDate: String?
    let viewCount: Int?
    let tags: [Tags]
    
    var body: some View {
            VStack(spacing: 10) {
                HStack {
                    AsyncImage(url: URL(string: user.profile_image_url!)) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height:40)
                    } placeholder: {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 40, height:40)
                    }
                    Spacer()
                        .frame(width: 10)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("@\(user.id!)")
                                .font(.system(size: 12, design: .rounded))
                            Text(user.name != "" ? "(\(user.name!))" : "")
                                .font(.system(size: 12, design: .rounded))
                        }
                        Text(createdDate!)
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    Spacer()
                }
                Text(title ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20))
                    .bold()
                    .lineLimit(2)
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag.name)
                            .lineLimit(1)
                            .font(.system(size: 10))
                            .padding(.all, 5)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                    Spacer()
                }
                HStack(spacing: 10) {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("\(likesCount ?? 0)")
                        .font(.system(size: 12))
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 150)
        
    }
}
