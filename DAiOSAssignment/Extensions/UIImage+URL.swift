//
//  UIImage+URL.swift
//  DAiOSAssignment
//
//  Created by VEER BAHADUR TIWARI on 17/07/18.
//  Copyright © 2018 docAnywhere. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    public func setImageFromServerURL(urlString: String) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
                
            })
            
        }).resume()
    }
}
