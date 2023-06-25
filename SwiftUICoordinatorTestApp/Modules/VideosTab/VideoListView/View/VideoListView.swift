//
//  VideoListView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 23.06.2023.
//

import SwiftUI
import AVKit

struct VideoListView<ViewModel>: View where ViewModel: VideoListViewModel {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        content
            .toolbar(.visible, for: .tabBar)
            .onAppear {
                if viewModel.presentables.count == 0 {
                    viewModel.load(page: 1)
                }
            }
    }
    
    private var content: AnyView {
        if viewModel.presentables.isEmpty {
            return CustomProgressView().toAnyView()
        } else {
            return videoList.toAnyView()
        }
    }
    
    private var videoList: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10.0) {
                ForEach(viewModel.presentables, id: \.id) { presentable in
                    NavigationLink(destination: FullVideoView(videoUrl: presentable.videoUrl,
                                                              userName: presentable.userName,
                                                              tags: presentable.tags,
                                                              likes: presentable.likes,
                                                              comments: presentable.comments,
                                                              views: presentable.views,
                                                              downloads: presentable.downloads)) {
                        CardVideoView(thumbnail: presentable.thumbnail)
                    }
                    
                }
                
                CustomProgressView()
                    .onAppear {
                        viewModel.loadNextPage()
                    }
            }
            .padding(.horizontal, 14.0)
            .padding(.top, 10)
        }
        .refreshable {
            viewModel.load(page: 1)
        }
    }
}
