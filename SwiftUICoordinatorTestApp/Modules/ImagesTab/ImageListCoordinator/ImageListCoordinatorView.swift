//
//  ImagesListCoordinatorView.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 17.06.2023.
//

import SwiftUI
import RxSwift

struct ImageListCoordinatorView: View {
    @ObservedObject var coordinator: ImageListCoordinator
    @State private var searchText: String = ""
    
    private let textDidChangeSubject = PublishSubject<String>()
    
    var body: some View {
        NavigationView {
            coordinator.imageListView(searchTextObservable: searchTextObservable())
                .navigationTitle("Images")
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .onChange(of: searchText) { textDidChangeSubject.onNext($0) }
    }
}

private extension ImageListCoordinatorView {
    func searchTextObservable() -> Observable<String> {
        textDidChangeSubject
            .asObservable()
            .skip(while: { $0.count != 0 && $0.count < 3 })
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
    }
}
