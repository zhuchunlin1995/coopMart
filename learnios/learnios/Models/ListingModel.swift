//
//  Listing.swift
//  learnios
//
//  Created by Guanming Qiao on 3/13/18.
//

import UIKit

struct ListingModel {
    
    var caption: String
    var comment: String
    var price: String
    var image: UIImage
    
    init(caption: String, comment: String, price: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.price = price
        self.image = image
    }
    
    init?(dictionary: [String: String]) {
        guard let caption = dictionary["Caption"], let comment = dictionary["Comment"], let price = dictionary["Price"], let photo = dictionary["Photo"],
            let image = UIImage(named: photo) else {
                return nil
        }
        self.init(caption: caption, comment: comment, price: price, image: image)
    }
}
