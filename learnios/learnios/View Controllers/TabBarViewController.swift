//
//  TabBarViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 3/20/18.
//

import UIKit
import AVFoundation

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    }
    func checkIfUserIsLoggedIn(){
        //check with firebase
        perform(#selector(handleLogout), with: nil, afterDelay: 0)
    }
    @objc func handleLogout() {
         //use firebase to sign out the current account
        let loginController = LoginController()        
        self.present(loginController, animated:true, completion: nil)
    }
}
