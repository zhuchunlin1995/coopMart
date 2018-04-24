//
//  AccountPassword.swift
//  learnios
//
//  Created by Jin on 4/24/18.
//

import Foundation

class AccountPassword{
    var account:String = ""
    var password:String = ""
    
    init(account:String,password:String) {
        self.account = account
        self.password = password
    }
    
    static func generateOne() -> AccountPassword {
        let account = RandomTool.generateGmail()
        let password  = RandomTool.generatePassword()
        return  AccountPassword(account:account,password:password)
    }
}


