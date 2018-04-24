//
//  CardViewCell.swift
//  learnios
//
//  Created by Guanming Qiao on 3/21/18.
//

import Foundation
import UIKit

import UIKit

class CardViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var listing: ListingModel? {
        didSet {
            if let listing = listing {
                profileImageView.image = listing.image
                nameLabel.text = listing.caption
                descriptionTextView.text = listing.comment
                priceLabel.text =
                    listing.price
            }
        }
    }
}
