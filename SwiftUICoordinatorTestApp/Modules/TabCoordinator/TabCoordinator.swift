//
//  TabCoordinator.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import Foundation
import SwiftUI

enum TabItem {
    case images
    case videos
}

final class TabCoordinator: ObservableObject {
    @Published var tab = TabItem.images
    
    func imagesTab() -> ImageListCoordinatorView {
        let coordinator = ImageListCoordinator()
        let view = ImageListCoordinatorView(coordinator: coordinator)
        return view
    }
    
    func videosTab() -> VideoListCoordinatorView {
        let coordinator = VideoListCoordinator()
        let view = VideoListCoordinatorView(coordinator: coordinator)
        return view
    }
}
