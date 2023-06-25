//
//  FullVideoView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 24.06.2023.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct FullVideoView: View {
    private let userName: String
    private let tags: String
    private let likes: Int
    private let comments: Int
    private let views: Int
    private let downloads: Int
    
    private let player: AVPlayer
    
    @State private var tabBarVisibility: Visibility = .hidden
    
    init(videoUrl: URL, userName: String, tags: String, likes: Int, comments: Int, views: Int, downloads: Int) {
        self.userName = userName
        self.tags = tags
        self.likes = likes
        self.comments = comments
        self.views = views
        self.downloads = downloads
        self.player = AVPlayer(url: videoUrl)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topPanel
            Spacer()
            VideoPlayer(player: player)
            Spacer()
            bottomPanel
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(userName)
        .toolbar(tabBarVisibility, for: .tabBar)
        .onAppear {
            player.play()
        }
        .onDisappear {
            tabBarVisibility = .visible
        }
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
