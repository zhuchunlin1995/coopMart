//
//  CartItemsDetailViewController.swift
//  learnios
//
//  Created by 万琳莉 on 23/04/2018.
//


import UIKit
import Firebase
import FirebaseAuth
import Foundation
import MessageUI



class CartItemDetailViewController: UIViewController {
    
    var listing: CartItemModel?
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
    }
    
    @IBAction func checkOutButtonTapped(_ sender: UIBarButtonItem) {
        guard let listing = listing else { return }
    }
    
    
    
    
    func displayInfo() {
        guard let listing = listing else { return }
        descriptionTextView.text = listing.comment
        nameLabel.text = listing.caption
        locationLabel.text = listing.price
        profileImageView.image = listing.image
    }
}


