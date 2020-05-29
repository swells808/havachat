//
//  ImageService.swift
//  havachat
//
//  Created by Sean Wells on 5/26/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, url, error in
            var downloadImage:UIImage?
            
            if let data = data {
                downloadImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(downloadImage)
            }
        }
        dataTask.resume()
    }
    
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
