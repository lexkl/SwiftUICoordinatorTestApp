//
//  VideoListViewModel.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 23.06.2023.
//

import Foundation
import SwiftUI
import RxSwift

struct VideoListPresentable {
    let id: Int
    let thumbnail: UIImage
    let videoUrl: URL
    let userName: String
    let tags: String
    let likes: Int
    let comments: Int
    let views: Int
    let downloads: Int
}

protocol VideoListViewModel: ObservableObject {
    var presentables: [VideoListPresentable] { get set }
    
    func load(page: Int)
    func loadNextPage()
}

final class VideoListViewModelImpl: VideoListViewModel {
    @Published var presentables = [VideoListPresentable]()
    
    private let provider: VideoListProvider
    private var searchTextObservable: Observable<String>
    private let disposeBag = DisposeBag()
    
    private var currentPage = 1
    private var searchText = ""
    
    init(provider: VideoListProvider, searchTextObservable: Observable<String>) {
        self.provider = provider
        self.searchTextObservable = searchTextObservable
        
        bind()
    }
    
    func load(page: Int) {
        currentPage = page
        provider.load(page: currentPage, searchText: searchText)
            .subscribe(onNext: { value in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    presentables.count == 0
                        ? presentables = [value]
                        : presentables.append(value)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func loadNextPage() {
        load(page: currentPage + 1)
    }
}

private extension VideoListViewModelImpl {
    func bind() {
        self.searchTextObservable
            .subscribe { [weak self] text in
                guard let self else { return }
                searchText = text
                load(page: 1)
            }
            .disposed(by: disposeBag)
    }
}
