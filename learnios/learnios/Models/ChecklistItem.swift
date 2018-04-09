//
//  ChecklistItem.swift
//  learnios
//
//  Created by 万琳莉 on 08/04/2018.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
