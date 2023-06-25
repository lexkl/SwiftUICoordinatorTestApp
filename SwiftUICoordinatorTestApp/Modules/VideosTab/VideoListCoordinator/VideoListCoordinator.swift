//
//  VideoListCoordinator.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import Foundation
import RxSwift
import SwiftUI
import Swinject

final class VideoListCoordinator: ObservableObject, Coordinator {
    func videoListView(searchTextObservable: Observable<String>) -> AnyView {
        let service = Container.shared.resolve(VideoService.self)!
        let provider = VideoListProvider(service: service)
        let viewModel = VideoListViewModelImpl(provider: provider,
                                               searchTextObservable: searchTextObservable)
        let view = VideoListView(viewModel: viewModel)
        
        return view.toAnyView()
    }
}
