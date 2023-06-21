//
//  Networker.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 19.06.2023.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa

enum ApiError: Error {
    case invalidUrl
    case parsingError
}

final class NetworkAgent {
    enum PixabayURL: String {
        case images = "imagesUrl"
        case videos = "videosUrl"
    }
    
    private let plistLoader: PlistLoader
    
    init(plistLoader: PlistLoader) {
        self.plistLoader = plistLoader
    }
    
    func requestJSON<T: Decodable>(urlKey: PixabayURL,
                                   method: HTTPMethod = .get,
                                   parameters: [String: String] = [:]) -> Observable<T> {
        var urlsPlist: [String: String]
        var privatePlist: [String: String]
        
        do {
            urlsPlist = try plistLoader.load(name: "URL")
            privatePlist = try plistLoader.load(name: "Private")
        } catch {
            return Observable.error(error)
        }
        
        guard let url = urlsPlist[urlKey.rawValue],
              let apiKey = privatePlist["apiKey"] else {
            return Observable.error(PlistError.invalidPlistContent)
        }
        
        let allParameters: [String: String] = ["key": apiKey].merging(parameters) { _, new in
            new
        }
        
        return RxAlamofire.requestJSON(method, url, parameters: allParameters)
            .map { (response, json) -> T in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let decodedResponse = try JSONDecoder().decode(T.self, from: jsonData)
                    return decodedResponse
                } catch {
                    throw error
                }
            }
    }
}
