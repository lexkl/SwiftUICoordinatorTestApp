//
//  ImageView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 22.06.2023.
//

import SwiftUI
import NukeUI

struct CardImageView: View {
    let imageUrl: URL
    
    @State private var startItemAnimation = false
    
    var body: some View {
        ZStack {
            LazyImage(url: imageUrl) { state in
                if let error = state.error {
                    Text(error.localizedDescription).toAnyView()
                } else if state.isLoading {
                    ProgressView().toAnyView()
                } else if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width - 28)
                        .frame(height: 200.0)
                        .cornerRadius(10.0)
                        .onAppear {
                            startItemAnimation = true
                        }
                        .toAnyView()
                } else {
                    EmptyView().toAnyView()
                }
            }
            .opacity(startItemAnimation ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 1), value: startItemAnimation)
        }
    }
}
