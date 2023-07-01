//
//  ImageProvider.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 19.06.2023.
//

import Foundation
import Swift
import Combine

struct ImageListProvider {
    private let service: ImageService
    
    init(service: ImageService) {
        self.service = service
    }
    
    func load(page: Int, searchText: String) -> AnyPublisher<[ImageListPresentable], Error> {
        service.load(page: page, searchText: searchText)
            .map { apiImages in
                apiImages.compactMap { apiImage in
                    guard let url = URL(string: apiImage.webformatURL) else {
                        return nil
                    }
                    
                    return ImageListPresentable(id: apiImage.id, imageUrl: url)
                }
            }
            .eraseToAnyPublisher()
    }
    
//    func load(page: Int, searchText: String) -> AnyPublisher<[ImageListPresentable], Error> {
//        service.load(page: page, searchText: searchText)
//            .flatMap { apiImages -> AnyPublisher<[ImageListPresentable], Error> in
//                Publishers.Sequence(sequence: apiImages)
//                    .flatMap { apiImage -> AnyPublisher<ImageListPresentable, Error> in
//                        service.download(imageUrl: apiImage.webformatURL)
//                            .map {
//                                ImageListPresentable(id: apiImage.id,
//                                                        image: $0,
//                                                        userName: apiImage.user,
//                                                        tags: apiImage.tags,
//                                                        likes: apiImage.likes,
//                                                        comments: apiImage.comments,
//                                                        views: apiImage.views,
//                                                        downloads: apiImage.downloads)
//                            }
//                            .eraseToAnyPublisher()
//                    }
//                    .collect()
//                    .eraseToAnyPublisher()
//            }
//            .eraseToAnyPublisher()
//    }
}
