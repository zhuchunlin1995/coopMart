//
//  ToDoItem.swift
//  learnios
//
//  Created by 万琳莉 on 01/03/2018.
//  Copyright © 2018 Linli. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    // A text description of this item
    var text: String
    
    // A Boolean value that determines the completed state of this item
    var completed: Bool
    
    init(text: String) {
        self.text = text
        self.completed = false
    }
}
