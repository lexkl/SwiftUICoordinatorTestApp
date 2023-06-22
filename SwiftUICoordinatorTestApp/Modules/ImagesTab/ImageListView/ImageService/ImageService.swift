//
//  ImageService.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 18.06.2023.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa
import SwiftUI

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
    
    private let concurrentQueue: DispatchQueue
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    init(networker: NetworkAgent) {
        self.networker = networker
        self.concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .concurrent)
        self.scheduler = ConcurrentDispatchQueueScheduler(queue: concurrentQueue)
    }
    
    func load(page: Int) -> Observable<[ApiImage]> {
        let apiImagesObservable: Observable<ApiImageResponse> = networker
            .requestJSON(urlKey: .images, parameters: ["page": page])
            .subscribe(on: scheduler)
        return apiImagesObservable.map { $0.hits }
    }
    
    func download(imageUrl: String) -> Observable<UIImage> {
        RxAlamofire.data(.get, imageUrl)
            .subscribe(on: scheduler)
            .compactMap { UIImage(data: $0) }
    }
}
