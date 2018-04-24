//
//  MyListingsViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 3/21/18.
//

import UIKit
import AnimatedCollectionViewLayout
import Firebase
import FirebaseAuth
import FirebaseStorage

class MyListingsViewController: UIViewController {
    
    @IBOutlet weak var newPostingButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var imagePicker = UIImagePickerController()
    let cellReuseIdentifer = "profileCell"
    let segueIdentifer = "profileSegue"
    var tableData: [ListingModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let background = UIImage(named: "Pattern")
        var imageView : UIImageView!
        // Load Data Here
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        newPostingButton.addTarget(self, action: #selector(newPostingButtonTapped), for: .touchUpInside)
        reloadData()
        setUpAnimatedCollectionViewLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifer {
            guard let detailViewController = segue.destination as? MyListingDetailViewController else { return }
            guard let cell = sender as? CardViewCell else { return }
            guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
            let selectedProfile = tableData[indexPath.item]
            detailViewController.listing = selectedProfile
        }
    }
    func reloadData(){
        let email = Auth.auth().currentUser?.email
        let db = Firestore.firestore()
        let collectRef = db.collection("users").document(email!).collection("items");
        let storage = Storage.storage()
        
        // retrieve all items in the item collections
        collectRef.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var listings: [ListingModel] = []
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
                            let item = ListingModel(caption: data["name"] as! String, email: data["email"] as! String, comment: data["description"] as! String, price: (data["price"] as? String)!, image: image!, url: (data["URL"] as? String)!)
                            listings.append(item)
                            self.tableData = listings
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension MyListingsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifer, for: indexPath) as! CardViewCell
        cell.backgroundColor = .white
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        
        cell.listing = tableData[indexPath.item]
        cell.profileImageView.backgroundColor = UIColor.black
        return cell
    }
    
    @objc func newPostingButtonTapped(sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let useExistingAction = UIAlertAction(title: "Use Existing", style: UIAlertActionStyle.default, handler: goToLibrary)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: takePhoto)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
    
        alertController.addAction(useExistingAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension MyListingsViewController: UICollectionViewDelegateFlowLayout {
    func setUpAnimatedCollectionViewLayout(){
        guard let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout else { return }
        layout.animator = RotateInOutAttributesAnimator()
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension MyListingsViewController: UINavigationControllerDelegate {
    func goToLibrary(alert: UIAlertAction) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhoto(alert: UIAlertAction) {
        let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
        cameraVC.delegate = self
        cameraVC.modalPresentationStyle = .overFullScreen
        present(cameraVC, animated: true, completion: nil)
    }
}

extension MyListingsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let confirmationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationViewController
        confirmationVC.delegate = self
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            confirmationVC.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            confirmationVC.image = image
        }
        else {
            confirmationVC.didNotGetImage(error: Error.self as! Error)
        }

        imagePicker.dismiss(animated: false, completion: nil)
        present(confirmationVC, animated: false, completion: nil)
    }
}

extension MyListingsViewController: CameraViewControllerDelegate {
    func cameraViewController(_ cameraViewController: CameraViewController, didTakePhoto image: UIImage) {
        let confirmationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationViewController
        confirmationVC.image = image
        confirmationVC.delegate = self
        confirmationVC.modalPresentationStyle = .fullScreen
        cameraViewController.dismiss(animated: false, completion: nil)
        present(confirmationVC, animated: false, completion: nil)
    }
}

extension MyListingsViewController: ConfirmationViewControllerDelegate {
    func didSelectPostItem(confirmationViewController: ConfirmationViewController) {
        //self.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func didSelectLibrary(confirmationViewController: ConfirmationViewController) {
        confirmationViewController.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        confirmationViewController.dismiss(animated: false, completion: nil)
        present(imagePicker, animated: false, completion: nil)
    }
    
    func didSelectTakePhoto(confirmationViewController: ConfirmationViewController) {
        let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
        cameraVC.delegate = self

        confirmationViewController.dismiss(animated: false, completion: nil)
        present(cameraVC, animated: false, completion: nil)
    }
}

