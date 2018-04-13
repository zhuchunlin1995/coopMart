//
//  ModifyProfileViewController.swift
//  learnios
//
//  Created by 万琳莉 on 30/03/2018.
//

import UIKit
import Firebase
import FirebaseAuth

class ModifyProfileViewController: UIViewController {
//    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var mProfilePicture: UIImageView!
    @IBOutlet weak var mMyName: UITextField!
    @IBOutlet weak var mMyEmail: UITextField!
    @IBOutlet weak var mMyLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let background = UIImage(named: "Pattern")
        var imageView : UIImageView!
        mProfilePicture.layer.cornerRadius = 90
        mProfilePicture.layer.masksToBounds = true
        mProfilePicture.layer.borderWidth = 2
        mProfilePicture.layer.borderColor = UIColor.white.cgColor
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
        
//        self.LogoutButton.addTarget(self, action: #selector(self.LogoutButtonTapped), for: .touchUpInside)
        
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {return}
            let data = document.data()
            self.mMyName.text = data!["name"] as? String
            self.mMyEmail.text = email
            self.mMyLocation.text = data!["school"] as? String
            let URL = data!["avatar"] as! String
            let httpsReference = storage.reference(forURL: URL)
            httpsReference.getData(maxSize: 10000 * 10000 * 10000){ data, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.mProfilePicture.image? = UIImage(named: "addProfile.png")!
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.mProfilePicture.image = image!
                }
            }
        }
        
    }
    
    //    func fillItems (){
    //        MyName.text = "Linli"
    //    }
    //    // instantiate a inputs container view
    //    let inputsContainerView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = UIColor.white
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        view.layer.cornerRadius = 5
    //        view.layer.masksToBounds = true
    //        return view
    //    }()
    
    @objc func updateButtonTapped(sender: UIButton) {
        
    }
}

