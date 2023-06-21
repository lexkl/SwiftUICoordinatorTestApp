//
//  ImagesListCoordinatorView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import SwiftUI

struct ImageListCoordinatorView: View {
    @ObservedObject var coordinator: ImageListCoordinator
    
    var body: some View {
        NavigationView {
            coordinator.imageListView()
                .navigationTitle("Images")
        }
    }
}

//struct ImageListCoordinatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageListCoordinatorView(coordinator: <#T##ImageListCoordinator#>)
//    }
//}
