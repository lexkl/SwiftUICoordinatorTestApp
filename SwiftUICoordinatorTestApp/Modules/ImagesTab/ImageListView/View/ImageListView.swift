//
//  ImageListView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 18.06.2023.
//

import SwiftUI

struct ImageListView<ViewModel>: View where ViewModel: ImageListViewModel {
    @ObservedObject var viewModel: ViewModel
    @State var startItemAnimation = false
    
    //private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        content
            .onAppear {
                if viewModel.presentables.count == 0 {
                    viewModel.load(page: 1)
                }
            }
    }
    
    private var content: AnyView {
        switch viewModel.viewState {
        case .loading:
            return loadingView.toAnyView()
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
                
                loadingView
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
    
    private var loadingView: some View {
        VStack {
            ProgressView()
        }
    }
}
