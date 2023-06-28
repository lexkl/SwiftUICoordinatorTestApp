//
//  VideoListProvider.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 23.06.2023.
//

import Foundation
import Swift
import AVFoundation
import Combine
import UIKit

struct VideoListProvider {
    private let service: VideoService
    
    init(service: VideoService) {
        self.service = service
    }
    
    func load(page: Int, searchText: String) -> AnyPublisher<VideoListPresentable, Error> {
        service.load(page: page, searchText: searchText)
            .flatMap { apiVideos in
                Publishers.Sequence(sequence: apiVideos)
                    .compactMap { apiVideo -> VideoListPresentable? in
                        guard let url = URL(string: apiVideo.videos.small.url),
                              let thumbnail = createThumbnail(videoUrl: url) else {
                            return nil
                        }
                        
                        return VideoListPresentable(id: apiVideo.id,
                                                    thumbnail: thumbnail,
                                                    videoUrl: url,
                                                    userName: apiVideo.user,
                                                    tags: apiVideo.tags,
                                                    likes: apiVideo.likes,
                                                    comments: apiVideo.comments,
                                                    views: apiVideo.views,
                                                    downloads: apiVideo.downloads)
                    }
                    .flatMap { presentable in
                        Just(presentable).eraseToAnyPublisher()
                    }
            }
            .eraseToAnyPublisher()
    }
    
    private func createThumbnail(videoUrl: URL) -> UIImage? {
        autoreleasepool {
            let asset: AVAsset = AVAsset(url: videoUrl)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            var cgImage: CGImage?
            
            do {
                cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            } catch {
                print(error)
                return nil
            }
            
            guard let cgImage,
                  let compressedData = UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.5),
                  let resultImage = UIImage(data: compressedData) else {
                return nil
            }
                  
            return resultImage
        }
        
    }
}
