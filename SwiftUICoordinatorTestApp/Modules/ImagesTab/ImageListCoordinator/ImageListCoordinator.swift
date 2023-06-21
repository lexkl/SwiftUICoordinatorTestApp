//
//  ImageListCoordinator.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import Foundation
import Swinject

final class ImageListCoordinator: ObservableObject, Coordinator {
    func imageListView() -> ImageListView {
        let service = Container.shared.resolve(ImageService.self)!
        let provider = ImageListProvider(service: service)
        let viewModel = ImageListViewModel(provider: provider)
        let view = ImageListView(viewModel: viewModel)
        
        return view
    }
}
