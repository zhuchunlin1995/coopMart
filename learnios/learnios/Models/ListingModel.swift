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
    var email: String?
    var URL: String?
    
    init(caption: String, email: String, comment: String, price: String, image: UIImage, url: String) {
        self.caption = caption
        self.comment = comment
        self.price = price
        self.image = image
        self.email = email
        self.URL = url
    }
    
    init?(dictionary: [String: String]) {
        guard let caption = dictionary["Caption"], let email = dictionary["Email"],let comment = dictionary["Comment"], let price = dictionary["Price"], let photo = dictionary["Photo"], let url = dictionary["URL"],
            let image = UIImage(named: photo) else {
                return nil
        }
        self.init(caption: caption, email: email, comment: comment, price: price, image: image, url: url)
    }
}
