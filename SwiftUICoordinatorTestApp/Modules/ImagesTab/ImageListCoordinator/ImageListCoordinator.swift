//
//  ImageListCoordinator.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import Foundation
import Swinject
import SwiftUI
import Combine

final class ImageListCoordinator: ObservableObject, Coordinator {
    func imageListView(searchTextPublisher: AnyPublisher<String, Never>) -> AnyView {
        let service = Container.shared.resolve(ImageService.self)!
        let provider = ImageListProvider(service: service)
        let viewModel = ImageListViewModelImpl(provider: provider,
                                               searchTextPublisher: searchTextPublisher)
        let view = ImageListView(viewModel: viewModel)
        
        return view.toAnyView()
    }
}
