//
//  Networker.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 19.06.2023.
//

import Foundation
import Combine

enum ApiError: Error {
    case invalidUrl
    case invalidRequest
    case emptyData
}

enum PixabayURL: String {
    case images = "imagesUrl"
    case videos = "videosUrl"
}

final class NetworkAgent {
    private let plistLoader: PlistLoader
    
    init(plistLoader: PlistLoader) {
        self.plistLoader = plistLoader
    }
    
    func request<T: Decodable>(urlKey: PixabayURL,
                               parameters: [String: String] = [:]) -> AnyPublisher<T, Error> {
        guard let url = try? getValueFromPlist(plistName: "URL", key: urlKey.rawValue),
              let apiKey = try? getValueFromPlist(plistName: "Private", key: "apiKey") else {
            return Fail(error: PlistError.invalidPlistContent).eraseToAnyPublisher()
        }
        
        let allParameters = ["key": apiKey].merging(parameters) { _, new in new }
        guard let request = urlRequest(url: url, parameters: allParameters) else {
            return Fail(error: ApiError.invalidRequest).eraseToAnyPublisher()
        }
        
        return URLSession.DataTaskPublisher(request: request, session: URLSession.shared)
            .print()
            .tryMap { result -> T in
                guard !result.data.isEmpty else {
                    throw ApiError.emptyData
                }
                
                return try JSONDecoder().decode(T.self, from: result.data)
            }
            .eraseToAnyPublisher()
    }
}

private extension NetworkAgent {
    func urlRequest(url: String, parameters: [String: String]) -> URLRequest? {
        guard var components = URLComponents(string: url) else {
            return nil
        }
        
        components.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        guard let url = components.url else {
            return nil
        }
                
        var request = URLRequest(url: url)
        request.timeoutInterval = 30.0
        request.httpMethod = "get"
        
        return request
    }
    
    func getValueFromPlist(plistName: String, key: String) throws -> String {
        let plist = try plistLoader.load(name: plistName)
        guard let value = plist[key] else {
            throw PlistError.invalidPlistContent
        }
        
        return value
    }
}
