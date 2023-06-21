//
//  PlistLoader.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 21.06.2023.
//

import Foundation

enum PlistError: Error {
    case invalidPlistPath
    case invalidPlistContent
}

struct PlistLoader {
    func load(name: String) throws -> [String: String] {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else {
            throw PlistError.invalidPlistPath
        }
        
        guard let content = NSDictionary(contentsOfFile: path) as? [String: String] else {
            throw PlistError.invalidPlistContent
        }
        
        return content
    }
}
