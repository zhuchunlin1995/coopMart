//
//  ViewController.swift
//  learnios
//
//  Created by 万琳莉 on 01/03/2018.
//  Copyright © 2018 Linli. All rights reserved.
//

import UIKit
//import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var toDoItems = [ToDoItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        //make tableView black under the cell user is dragging
        tableView.backgroundColor = UIColor.black
        tableView.rowHeight = 50.0
        //in old version: registerClass
        //tells the tableView to use TableViewCell class defined by ys whenever it needs a cell with reuse identifier "cell"
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        if toDoItems.count > 0 {
            return
        }
        
        toDoItems.append(ToDoItem(text: "to do 0"))
        toDoItems.append(ToDoItem(text: "to do 1"))
        toDoItems.append(ToDoItem(text: "to do 2"))
        toDoItems.append(ToDoItem(text: "to do 3"))
        toDoItems.append(ToDoItem(text: "to do 4"))
        toDoItems.append(ToDoItem(text: "to do 5"))
        toDoItems.append(ToDoItem(text: "to do 6"))
        toDoItems.append(ToDoItem(text: "to do 7"))
        toDoItems.append(ToDoItem(text: "to do 8"))

    }
    
    //Add the required UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    //modify type of indexPath from NSIndexPath to IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let item = toDoItems[indexPath.row]
        //get rid of the highlighting that happens when select a table cell
        cell.selectionStyle = .none
        cell.textLabel?.text = item.text
        cell.textLabel?.backgroundColor = UIColor.clear
        return cell
    }
    
    //set background color of each row
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: val, green: 0.0, blue: 0.4, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(index: indexPath.row)
    }

}

