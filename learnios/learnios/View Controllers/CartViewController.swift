//
//  ViewController.swift
//  learnios
//
//  Created by 万琳莉 on 01/03/2018.
//  Copyright © 2018 Linli. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class CartViewController: UITableViewController {
    //construct
    let segueIdentifer = "cartSegue"
    var items: [CartItemModel] = []
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let db = Firestore.firestore()
        let collectRef = db.collection("items");
        let storage = Storage.storage()
        // retrieve all items in the item collections
        collectRef.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var listings: [CartItemModel] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let URL = data["URL"] as! String
                    print(URL)
                    let httpsReference = storage.reference(forURL: URL)
                    
                    
                    httpsReference.getData(maxSize: 10000 * 10000 * 10000){ imageData, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            // Data for "images/island.jpg" is returned
                            let image = UIImage(data: imageData!)
                            let item = CartItemModel(caption: data["name"] as! String, comment: data["description"] as! String, price: (data["price"] as? String)!, image: UIImage(named: "02.png")!)
                            listings.append(item)
                            self.items = listings
                            self.tableView?.reloadData()
                        }
                    }
                }
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifer {
            guard let detailViewController = segue.destination as? CartItemDetailViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = self.tableView?.indexPath(for: cell) else { return }
            let selectedProfile = items[indexPath.row]
            detailViewController.listing = selectedProfile
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tell the table view you have just one row of data
    //_ tableView means the method does not need to have the parameter name specified when calling the method
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //grabs a copy of the portotype cell and gives that back to the table xiew, again with a return statement
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if let tells Swift that you only want to perform the code inside the if consition only there really is a UITableViewCell object
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
//            item.toggleChecked()
            configureCheckmark(for: cell, at: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //1
        items.remove(at: indexPath.row)
        
        //2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //garantee the view and data is consistent
    //congigure checkmark for this cell at that indexPath, always include those external parameter names
    func configureCheckmark(for cell: UITableViewCell,
                            at indexPath: IndexPath) {
        let item = items[indexPath.row]
        
//        if item.checked {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
    }
    
    func configureText(for cell: UITableViewCell, with item: CartItemModel) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.caption
    }
    
    @IBAction func addItem() {
//        let newRowIndex = items.count
//        let item = CartItemModel()
//        item.text = "I am a new row"
//        item.checked = false
//        items.append(item)
//
//        //tell the table view about this new row so it can add a new cell for that row. Table views use index-paths to identify rows, so make an IndexPath object that points to the new row, using the row number from the newRowIndex variable
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
    }

}

