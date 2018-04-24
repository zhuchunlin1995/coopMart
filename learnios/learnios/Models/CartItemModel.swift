//
//  CartItemModel.swift
//  learnios
//
//  Created by 万琳莉 on 23/04/2018.
//

import UIKit

struct CartItemModel {
    
    var caption: String?
    var comment: String?
    var price: String?
    var image: UIImage?
    
    
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
    
    static func cartItems() -> [CartItemModel] {
        // Temporary Dummy Data
        let listing = [CartItemModel(caption: "abc", comment: "description1", price: "$100", image: UIImage(named: "01")!), CartItemModel(caption: "item2", comment: "comment2", price: "$200", image: UIImage(named: "02")!), CartItemModel(caption: "item3", comment: "comment3", price: "$300", image: UIImage(named: "03")!)]
        return listing
    }
    
}
