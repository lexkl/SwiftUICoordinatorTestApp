//
//  VideoListProvider.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 23.06.2023.
//

import Foundation
import RxSwift
import Swift
import AVFoundation

struct VideoListProvider {
    private let service: VideoService
    
    init(service: VideoService) {
        self.service = service
    }
    
    func load(page: Int, searchText: String) -> Observable<VideoListPresentable> {
        service.load(page: page, searchText: searchText)
            .flatMap { apiVideos -> Observable<VideoListPresentable> in
                return Observable.from(apiVideos)
                    .compactMap { apiVideo -> VideoListPresentable? in
                        guard let url = URL(string: apiVideo.videos.small.url) else {
                            return nil
                        }
                        
                        return VideoListPresentable(id: apiVideo.id,
                                                    thumbnail: createThumbnail(videoUrl: url),
                                                    videoUrl: url,
                                                    userName: apiVideo.user,
                                                    tags: apiVideo.tags,
                                                    likes: apiVideo.likes,
                                                    comments: apiVideo.comments,
                                                    views: apiVideo.views,
                                                    downloads: apiVideo.downloads)
                    }
            }
    }
    
    private func createThumbnail(videoUrl: URL) -> UIImage {
        let asset: AVAsset = AVAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        var thumbnail = UIImage()
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            thumbnail = UIImage(cgImage: thumbnailImage)
        } catch {
            print(error)
        }
        return thumbnail
    }
}
