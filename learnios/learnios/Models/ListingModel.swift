//
//  Listing.swift
//  learnios
//
//  Created by Guanming Qiao on 3/13/18.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

struct ListingModel {
    
    var caption: String
    var comment: String
    var price: String
    var image: UIImage
    static var listing: [ListingModel] = []
    
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
    
    static func myListings() -> [ListingModel] {
        // Temporary Dummy Data
        let listing = [ListingModel(caption: "item1", comment: "comment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhudcomment1dsassdasdasdahciuhhud", price: "$100", image: UIImage(named: "01")!), ListingModel(caption: "item2", comment: "comment2", price: "$200", image: UIImage(named: "02")!), ListingModel(caption: "item3", comment: "comment3", price: "$300", image: UIImage(named: "03")!)]
        return listing
    }
    
    static func allListings() -> [ListingModel] {
        var listing: [ListingModel] = []
        allListingsAsn(completion: {listing = self.listing})
        return listing
    }
    
    static func allListingsAsn(completion: @escaping () -> Void ) {
        let db = Firestore.firestore()
        let collectRef = db.collection("items");
        let storage = Storage.storage()
       
        // retrieve all items in the item collections
        collectRef.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let URL = data["URL"] as! String
                    print(URL)
                    let httpsReference = storage.reference(forURL: URL)
                
                    httpsReference.getData(maxSize: 10000 * 10000 * 10000){ imageData, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            // Data for "images/island.jpg" is returned
                            let image = UIImage(data: imageData!)
                            let item = ListingModel(caption: data["name"] as! String, comment: data["description"] as! String, price: (data["price"] as? String)!, image: image!)
                            self.listing.append(item)
                            completion()
                        }
                    }
                }
            }
        }
    }
}
