//
//  ImageView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 22.06.2023.
//

import SwiftUI

struct CardImageView: View {
    let image: UIImage
    
    @State private var startItemAnimation = false
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.size.width - 28)
                .frame(height: 200.0)
                .cornerRadius(10.0)
                .opacity(startItemAnimation ? 1.0 : 0.0)
                .offset(x: 0, y: startItemAnimation ? -10 : 0)
                .animation(.easeInOut(duration: 1), value: startItemAnimation)
        }
        .onAppear {
            startItemAnimation = true
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        CardImageView(image: UIImage(systemName: "photo")!)
    }
}
