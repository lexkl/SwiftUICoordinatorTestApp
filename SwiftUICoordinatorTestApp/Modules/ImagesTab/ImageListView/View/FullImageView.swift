//
//  FullImageView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 21.06.2023.
//

import SwiftUI

struct FullImageView: View {
    let image: UIImage
    let userName: String
    let tags: String
    let likes: Int
    let comments: Int
    let views: Int
    let downloads: Int
    
    var body: some View {
        VStack(spacing: 0) {
            topPanel
            Spacer()
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            Spacer()
            bottomPanel
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(userName)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private var topPanel: some View {
        Text("Tags: \(tags)")
            .font(.system(size: 16, weight: .regular))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color.gray)
            .padding(.leading, 10)
            .padding(.top, 20)
    }
    
    private var bottomPanel: some View {
        HStack(spacing: 15.0) {
            HStack {
                Image(systemName: "eye")
                    .foregroundColor(Color(UIColor.systemBlue))
                Text(String(views))
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Image(systemName: "heart")
                    .foregroundColor(Color(UIColor.systemBlue))
                Text(String(likes))
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Image(systemName: "message")
                    .foregroundColor(Color(UIColor.systemBlue))
                Text(String(comments))
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Image(systemName: "arrow.down.to.line.compact")
                    .foregroundColor(Color(UIColor.systemBlue))
                Text(String(downloads))
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity)
        }
        .opacity(0.8)
        .padding(.horizontal, 10)
    }
}

struct FullImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullImageView(image: UIImage(systemName: "photo")!,
                      userName: "user",
                      tags: "blossom, bloom, flower",
                      likes: 0,
                      comments: 0,
                      views: 0,
                      downloads: 0)
    }
}
