//
//  VideoService.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 23.06.2023.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa
import SwiftUI

struct VideoData: Decodable {
    let url: String
    let width: Int
    let height: Int
    let size: Int
}

struct Videos: Decodable {
    let large: VideoData
    let medium: VideoData
    let small: VideoData
    let tiny: VideoData
}

struct ApiVideo: Decodable {
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let duration: Int
    let picture_id: String
    let videos: Videos
    let views: Int
    let downloads: Int
    let likes: Int
    let comments: Int
    let user_id: Int
    let user: String
    let userImageURL: String
}

struct ApiVideoResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [ApiVideo]
}

final class VideoService {
    private let networker: NetworkAgent
    
    private let concurrentQueue: DispatchQueue
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    init(networker: NetworkAgent) {
        self.networker = networker
        self.concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .concurrent)
        self.scheduler = ConcurrentDispatchQueueScheduler(queue: concurrentQueue)
    }
    
    func load(page: Int, searchText: String) -> Observable<[ApiVideo]> {
        let parameters = [
            "q": searchText,
            "page": page
        ] as [String : Any]
        
        let apiVideosObservable: Observable<ApiVideoResponse> = networker
            .requestJSON(urlKey: .videos, parameters: parameters)
            .subscribe(on: scheduler)
            .observe(on: scheduler)
        return apiVideosObservable.map { $0.hits }
    }
}
