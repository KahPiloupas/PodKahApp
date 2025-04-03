//
//  ImageCache.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 02/04/25.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
