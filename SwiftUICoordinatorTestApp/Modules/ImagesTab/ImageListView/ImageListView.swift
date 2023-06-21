//
//  ImageListView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 18.06.2023.
//

import SwiftUI

struct ImageListView: View {
    @ObservedObject var viewModel: ImageListViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(viewModel.presentables, id: \.id) {
                    Image(uiImage: $0.image)
                }
            }
        }
        .refreshable {
            viewModel.load()
        }
        .onAppear {
            viewModel.load()
        }
    }
}

//struct ImageListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageListView()
//    }
//}
