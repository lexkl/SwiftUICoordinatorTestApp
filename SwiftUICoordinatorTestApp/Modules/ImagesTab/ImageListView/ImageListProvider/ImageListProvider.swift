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
    
    func load(page: Int) -> Observable<[ImageListPresentable]> {
        service.load(page: page)
            .flatMap { apiImages -> Observable<[ImageListPresentable]> in
                let observables = apiImages.map { apiImage in
                    service.download(imageUrl: apiImage.webformatURL)
                        .map { ImageListPresentable(id: apiImage.id,
                                                    image: $0,
                                                    userName: apiImage.user,
                                                    tags: apiImage.tags,
                                                    likes: apiImage.likes,
                                                    comments: apiImage.comments,
                                                    views: apiImage.views,
                                                    downloads: apiImage.downloads) }
                }
                
                return Observable.zip(observables)
            }
    }
}
