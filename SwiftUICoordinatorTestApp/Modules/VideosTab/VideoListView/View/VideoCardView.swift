//
//  VideoCardView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 24.06.2023.
//

import AVFoundation
import SwiftUI

struct CardVideoView: View {
    @State private var startItemAnimation = false
    
    let thumbnail: UIImage
    
    var body: some View {
        Image(uiImage: thumbnail)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 200.0)
            .cornerRadius(10.0)
            .opacity(startItemAnimation ? 1.0 : 0.0)
            .offset(x: 0, y: startItemAnimation ? -10 : 0)
            .animation(.easeInOut(duration: 1), value: startItemAnimation)
            .onAppear {
                startItemAnimation = true
            }
    }
}
