//
//  ImageListViewModel\.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 18.06.2023.
//

import Foundation
import SwiftUI
import RxSwift

enum ImageListViewState {
    case loading
    case loaded
}

struct ImageListPresentable {
    let id: Int
    let image: UIImage
    let userName: String
    let tags: String
    let likes: Int
    let comments: Int
    let views: Int
    let downloads: Int
}

protocol ImageListViewModel: ObservableObject {
    var presentables: [ImageListPresentable] { get set }
    var viewState: ImageListViewState { get set }
    
    func load(page: Int)
    func loadNextPage()
}

final class ImageListViewModelImpl: ImageListViewModel {
    @Published var presentables = [ImageListPresentable]()
    @Published var viewState = ImageListViewState.loading
    
    private let provider: ImageListProvider
    private let disposeBag = DisposeBag()
    
    private var currentPage = 1
    
    init(provider: ImageListProvider) {
        self.provider = provider
    }
    
    func load(page: Int) {
        currentPage = page
        provider.load(page: currentPage)
            .subscribe(onNext: { [weak self] values in
                guard let self else { return }
                presentables.count == 0
                    ? presentables = values
                    : presentables.append(contentsOf: values)
                viewState = .loaded
            })
            .disposed(by: disposeBag)
    }
    
    func loadNextPage() {
        load(page: currentPage + 1)
    }
}
