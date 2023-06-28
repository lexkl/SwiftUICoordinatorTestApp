//
//  ImagesListCoordinatorView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import SwiftUI
import Combine

struct ImageListCoordinatorView: View {
    @ObservedObject var coordinator: ImageListCoordinator
    @State private var searchText: String = ""
    
    private let textDidChangeSubject = PassthroughSubject<String, Never>()
    private var textDidChangePublisher: AnyPublisher<String, Never> {
        textDidChangeSubject
            .drop { $0.count != 0 && $0.count < 3 }
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        NavigationView {
            coordinator.imageListView(searchTextPublisher: textDidChangePublisher)
                .navigationTitle("Images")
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .onChange(of: searchText) { textDidChangeSubject.send($0) }
    }
}
