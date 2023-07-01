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
        ZStack {
            switch viewModel.viewState {
            case .loading:
                CustomProgressView()
            case .loaded:
                imageList
            }
        }
        .toolbar(.visible, for: .tabBar)
        .onAppear {
            if viewModel.presentables.count == 0 {
                viewModel.load(page: 1)
            }
        }
    }
    
    private var imageList: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10.0) {
                ForEach(viewModel.presentables, id: \.id) { presentable in
                    NavigationLink(destination: EmptyView()) {
                        CardImageView(imageUrl: presentable.imageUrl)
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
