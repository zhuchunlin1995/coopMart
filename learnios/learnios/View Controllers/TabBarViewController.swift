//
//  TabBarViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 3/20/18.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    }
    func checkIfUserIsLoggedIn(){
        if (Auth.auth().currentUser?.uid == nil) {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    @objc func handleLogout() {
        try! Auth.auth().signOut()
        let loginController = LoginController()
        self.present(loginController, animated:true, completion: nil)
    }
}
