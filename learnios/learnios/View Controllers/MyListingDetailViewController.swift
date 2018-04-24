//
//  MyListingDetailViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 3/21/18.
//

import UIKit
import Firebase
import FirebaseAuth

class MyListingDetailViewController: UIViewController {
    
    var listing: ListingModel?
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        displayInfo()
    }
    
    @IBAction func AddCartButtonTapped(_ sender: UIBarButtonItem) {
        guard let listing = listing else { return }
        
        let cartItem: [String: Any] = [
            "name":listing.caption,
            "description": listing.comment,
            "price": listing.price,
        ]
        
        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.email)!).collection("cartList").document(listing.caption).setData([
                "name":listing.caption,
                "description": listing.comment,
                "price": listing.price,
            ])
        let optionMenu = UIAlertController(title: "Item added to the cart", message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        optionMenu.addAction(OKAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func displayInfo() {
        guard let listing = listing else { return }
        descriptionTextView.text = listing.comment
        nameLabel.text = listing.caption
        locationLabel.text = listing.price
        profileImageView.image = listing.image
    }
}

