//
//  SharedURLSession.swift
//  GoOutside
//
//  Created by Thomas McKanna on 1/27/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

struct SharedURLSession {
    internal let session: URLSession
    
    init?() {
        
        let defaultConfiguration = URLSessionConfiguration.default
        
        // configuring caching behavior for the default session
        
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        let cacheURL = cachesDirectoryURL.appendingPathComponent("MyCache")
        
        let diskPath = cacheURL.path
        
        let cache = URLCache(memoryCapacity: 16384, diskCapacity: 268435456, diskPath: diskPath)
        
        defaultConfiguration.urlCache = cache
        
        defaultConfiguration.requestCachePolicy = .useProtocolCachePolicy
        
        session = URLSession(configuration: defaultConfiguration)
    }
    
    func end() {
        session.invalidateAndCancel()
    }
}
