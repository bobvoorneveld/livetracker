//
//  ImageCache.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 27/06/2021.
//

import SwiftUI

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    private init() {}

    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    static let shared = ImageCache()
}
