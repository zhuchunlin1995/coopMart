//
//  Listing.swift
//  learnios
//
//  Created by Guanming Qiao on 3/13/18.
//

import UIKit

struct Listing {
    
    var caption: String
    var comment: String
    var image: UIImage
    
    
    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    init?(dictionary: [String: String]) {
        guard let caption = dictionary["Caption"], let comment = dictionary["Comment"], let photo = dictionary["Photo"],
            let image = UIImage(named: photo) else {
                return nil
        }
        self.init(caption: caption, comment: comment, image: image)
    }
    
    static func allListings() -> [Listing] {
        var listing = [Listing]()
        // Are we reading from plist? We need to get in touch with firebase here.
        guard let URL = Bundle.main.url(forResource: "Listings", withExtension: "plist"),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
                return listing
        }
        for dictionary in photosFromPlist {
            if let photo = Listing(dictionary: dictionary) {
                listing.append(photo)
            }
        }
        return listing
    }
    
}
