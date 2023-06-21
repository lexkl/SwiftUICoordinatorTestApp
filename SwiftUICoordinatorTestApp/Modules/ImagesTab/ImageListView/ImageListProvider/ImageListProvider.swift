//
//  ImageProvider.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 19.06.2023.
//

import Foundation
import RxSwift
import Swift

struct ImageListProvider {
    private let service: ImageService
    
    init(service: ImageService) {
        self.service = service
    }
    
    func load() -> Observable<[ImageListPresentable]> {
        service.load()
            .flatMap { apiImages -> Observable<[ImageListPresentable]> in
                let observables = apiImages.map { apiImage in
                    service.download(imageUrl: apiImage.webformatURL)
                        .map { ImageListPresentable(id: apiImage.id, image: $0) }
                }
                
                return Observable.zip(observables)
            }
    }
}
