//
//  SwiftUICoordinatorTestAppApp.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 16.06.2023.
//

import SwiftUI

@main
struct SwiftUICoordinatorTestAppApp: App {
    @StateObject var coordinator = TabCoordinator()
    var body: some Scene {
        WindowGroup {
            TabCoordinatorView(coordinator: coordinator)
        }
    }
}
