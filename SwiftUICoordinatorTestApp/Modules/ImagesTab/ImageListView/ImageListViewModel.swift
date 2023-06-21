//
//  ImageListViewModel\.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 18.06.2023.
//

import Foundation
import SwiftUI
import RxSwift

struct ImageListPresentable {
    let id: Int
    let image: UIImage
}

final class ImageListViewModel: ObservableObject {
    @Published var presentables = [ImageListPresentable]()
    
    private let provider: ImageListProvider
    private let disposeBag = DisposeBag()
    
    init(provider: ImageListProvider) {
        self.provider = provider
    }
    
    func load() {
        provider.load()
            .subscribe(onNext: { [weak self] values in
                guard let self else { return }
                presentables = values
            })
            .disposed(by: disposeBag)
    }
}
