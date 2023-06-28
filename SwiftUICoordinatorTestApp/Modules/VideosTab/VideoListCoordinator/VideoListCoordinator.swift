//
//  VideoListCoordinator.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import Foundation
import SwiftUI
import Swinject
import Combine

final class VideoListCoordinator: ObservableObject, Coordinator {
    func videoListView(searchTextPublisher: AnyPublisher<String, Never>) -> AnyView {
        let service = Container.shared.resolve(VideoService.self)!
        let provider = VideoListProvider(service: service)
        let viewModel = VideoListViewModelImpl(provider: provider,
                                               searchTextPublisher: searchTextPublisher)
        let view = VideoListView(viewModel: viewModel)
        
        return view.toAnyView()
    }
}
