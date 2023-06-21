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

protocol Coordinator {
    
}

final class TabCoordinator: ObservableObject, Coordinator {
    
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
