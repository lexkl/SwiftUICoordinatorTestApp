//
//  ImageListView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 18.06.2023.
//

import SwiftUI

struct ImageListView<ViewModel>: View where ViewModel: ImageListViewModel {
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
        switch viewModel.viewState {
        case .loading:
            return CustomProgressView().toAnyView()
        case .loaded:
            return imageList.toAnyView()
        }
    }
    
    private var imageList: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10.0) {
                ForEach(viewModel.presentables, id: \.id) { presentable in
                    NavigationLink(destination: FullImageView(image: presentable.image,
                                                              userName: presentable.userName,
                                                              tags: presentable.tags,
                                                              likes: presentable.likes,
                                                              comments: presentable.comments,
                                                              views: presentable.views,
                                                              downloads: presentable.downloads)) {
                        CardImageView(image: presentable.image)
                    }
                }
                
                CustomProgressView()
                    .onAppear {
                        viewModel.loadNextPage()
                    }
            }
            .padding(.top, 10)
        }
        .refreshable {
            viewModel.load(page: 1)
        }
    }
}
