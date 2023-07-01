//
//  ImageListViewModel\.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 18.06.2023.
//

import Foundation
import SwiftUI
import Combine

enum ImageListViewState {
    case loading
    case loaded
}

struct ImageListPresentable {
    let id: Int
    let imageUrl: URL
}

protocol ImageListViewModel: ObservableObject {
    var presentables: [ImageListPresentable] { get set }
    var viewState: ImageListViewState { get set }
    
    func load(page: Int)
    func loadNextPage()
}

final class ImageListViewModelImpl: ImageListViewModel {
    var presentables = [ImageListPresentable]()
    @Published var viewState = ImageListViewState.loading
    
    private let provider: ImageListProvider
    private var searchTextPublisher: AnyPublisher<String, Never>
    
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var searchText = ""
    
    init(provider: ImageListProvider, searchTextPublisher: AnyPublisher<String, Never>) {
        self.provider = provider
        self.searchTextPublisher = searchTextPublisher
        
        bind()
    }
    
    func load(page: Int) {
        currentPage = page
        provider.load(page: currentPage, searchText: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] values in
                guard let self else { return }
                presentables.count == 0
                    ? presentables = values
                    : presentables.append(contentsOf: values)
                viewState = .loaded
            })
            .store(in: &cancellables)
    }
    
    func loadNextPage() {
        load(page: currentPage + 1)
    }
}

private extension ImageListViewModelImpl {
    func bind() {
        searchTextPublisher
            .sink { [weak self] text in
                guard let self else { return }
                searchText = text
                load(page: 1)
            }
            .store(in: &cancellables)
    }
}
