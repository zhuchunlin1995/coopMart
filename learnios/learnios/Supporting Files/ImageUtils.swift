//
//  ImageUtils.swift
//  learnios
//
//  Created by Guanming Qiao on 4/8/18.
//

import Foundation
import UIKit

class ImageUtils {
    // Need to add items to firebase here, then reloading in mylistingView will work
    static func saveCached(image: UIImage, username: String, index: Int) -> Bool {
        let fileManager = FileManager.default
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appending("/Listing_\(String(username))_\(String(index)).png")
            fileManager.createFile(atPath: filename as String, contents: data, attributes: nil)
            print(filename)
            return true
        }
        return false
    }
    
    static func saveToPhotosAlbum(image: UIImage?) -> Bool {
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            return true
        }
        return false
    }
    
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    static func flipImageLeftRight(_ image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width, y: image.size.height)
        context.scaleBy(x: -image.scale, y: -image.scale)
        
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
