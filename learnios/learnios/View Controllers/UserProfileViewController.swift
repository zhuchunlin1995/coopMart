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
    override func viewDidLoad() {
        super.viewDidLoad()
        LogoutButton.addTarget(self, action: #selector(LogoutButtonTapped), for: .touchUpInside)
    }
     @objc func LogoutButtonTapped(sender: UIButton) {
        try! Auth.auth().signOut()
        let loginController = LoginController()
        self.present(loginController, animated:true, completion: nil)
    }
}
