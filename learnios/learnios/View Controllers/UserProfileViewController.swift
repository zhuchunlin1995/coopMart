//
//  UserProfileViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 3/28/18.
//

import UIKit
import Firebase
import FirebaseAuth

class UserProfileViewController: UIViewController {
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var MyName: UILabel!
    @IBOutlet weak var MyEmail: UILabel!
    @IBOutlet weak var MyLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let background = UIImage(named: "Pattern")
        var imageView : UIImageView!
        ProfilePicture.layer.cornerRadius = 90
        ProfilePicture.layer.masksToBounds = true
        ProfilePicture.layer.borderWidth = 2
        ProfilePicture.layer.borderColor = UIColor.white.cgColor
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let email = Auth.auth().currentUser?.email
        
        let docRef = db.collection("users").document(email!);
        
        self.LogoutButton.addTarget(self, action: #selector(self.LogoutButtonTapped), for: .touchUpInside)
        
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {return}
            let data = document.data()
            self.MyName.text = data!["name"] as? String
            self.MyEmail.text = email
            self.MyLocation.text = data!["school"] as? String
            let URL = data!["avatar"] as! String
            let httpsReference = storage.reference(forURL: URL)
            httpsReference.getData(maxSize: 10000 * 10000 * 10000){ data, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.ProfilePicture.image? = UIImage(named: "addProfile.png")!
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.ProfilePicture.image = image!
                }
            }
        }
        
    }
    
     @objc func LogoutButtonTapped(sender: UIButton) {
        try! Auth.auth().signOut()
        let loginController = LoginController()
        self.present(loginController, animated:true, completion: nil)
    }
}
