//
//  TabCoordinatorView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import SwiftUI

struct TabCoordinatorView: View {
    @ObservedObject var coordinator: TabCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.tab) {
            coordinator.imagesTab()
                .tabItem { Label("Images", systemImage: "photo") }
                .tag(TabItem.images)
            
            coordinator.videosTab()
                .tabItem { Label("Videos", systemImage: "video") }
                .tag(TabItem.videos)
        }
    }
}

struct TabCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        TabCoordinatorView(coordinator: TabCoordinator())
    }
}
