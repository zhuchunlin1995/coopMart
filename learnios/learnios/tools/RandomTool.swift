//
//  RandomTool.swift
//  learnios
//
//  Created by Jin Yan on 4/24/18.
//

import Foundation
class RandomTool {
    static let characters:[String] = ["1","2","3","4","5","6","7","8","9","0","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    
    static func generateRadom(num: Int) -> String {
        var ret = ""
        for _ in 0..<num {
            let temp = Int(arc4random() % UInt32(characters.count))
            ret.append(characters[temp])
        }
        return ret
    }
    static func generateGmail() -> String {
        let temp = Int(arc4random() % 3)+8
        var radom = generateRadom(num:temp)
        radom.append("@gmail.com")
        return radom
    }
    static func generatePassword() -> String {
        let temp = Int(arc4random() % 3)+8
        let radom = generateRadom(num:temp)
        return radom
    }
    
    
    
}

