//
//  Swinject.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 20.06.2023.
//

import Foundation
import Swinject

enum SwinjectError: Error {
    case unableToRegisterDependency
}

extension Container {
    static let shared: Container = {
        let container = Container()
        
        registerUtils(container: container)
        registerNetworkUtils(container: container)
        registerServices(container: container)
        
        return container
    }()
}

private extension Container {
    static func registerUtils(container: Container) {
        container.register(PlistLoader.self) { _ in
            PlistLoader()
        }
    }
    
    static func registerNetworkUtils(container: Container) {
        container.register(NetworkAgent.self) { resolver in
            let loader = resolver.resolve(PlistLoader.self)!
            return NetworkAgent(plistLoader: loader)
        }
    }
    static func registerServices(container: Container) {
        container.register(ImageService.self) { resolver in
            let networker = resolver.resolve(NetworkAgent.self)!
            return ImageService(networker: networker)
        }
    }
}
