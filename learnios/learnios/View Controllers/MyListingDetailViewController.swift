//
//  MyListingDetailViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 3/21/18.
//

import UIKit

class MyListingDetailViewController: UIViewController {
    
    var listing: ListingModel?
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
    }
    
    func displayInfo() {
        guard let listing = listing else { return }
        descriptionTextView.text = listing.comment
        nameLabel.text = listing.caption
        locationLabel.text = listing.price
        profileImageView.image = listing.image
    }
}

