//
//  ImageService.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 18.06.2023.
//

import Foundation
import Alamofire
import SwiftUI
import Combine

struct ApiImage: Decodable {
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: String
    let webformatWidth: Int
    let webformatHeight: Int
    let largeImageURL: String
    let fullHDURL: String?
    let imageURL: String?
    let imageWidth: Int
    let imageHeight: Int
    let imageSize: Int
    let views: Int
    let downloads: Int
    let likes: Int
    let comments: Int
    let user_id: Int
    let user: String
    let userImageURL: String
}

struct ApiImageResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [ApiImage]
}

final class ImageService {
    private let networker: NetworkAgent
    
    init(networker: NetworkAgent) {
        self.networker = networker
    }
    
    func load(page: Int, searchText: String) -> AnyPublisher<[ApiImage], Error> {
        let parameters = [
            "q": searchText,
            "page": page
        ] as [String : Any]
        
        let apiImagesResponsePublisher: AnyPublisher<ApiImageResponse, Error> =
            networker.requestJSON(urlKey: .images, parameters: parameters)
        
        return apiImagesResponsePublisher
            .map { $0.hits }
            .eraseToAnyPublisher()
    }
    
    func download(imageUrl: String) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: imageUrl) else {
            return Fail(error: ApiError.invalidUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { data, _ in
                UIImage(data: data)
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
