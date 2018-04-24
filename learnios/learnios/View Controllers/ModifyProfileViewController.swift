//
//  ModifyProfileViewController.swift
//  learnios
//
//  Created by 万琳莉 on 30/03/2018.
//

import UIKit
import Firebase
import FirebaseAuth

//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

class ModifyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var mProfilePicture: UIImageView!
    @IBOutlet weak var mMyName: UITextField!
    @IBOutlet weak var mMyEmail: UITextField!
    @IBOutlet weak var mMyLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let background = UIImage(named: "Pattern")
        var imageView : UIImageView!
        mProfilePicture.layer.cornerRadius = 90
        mProfilePicture.layer.masksToBounds = true
        mProfilePicture.layer.borderWidth = 2
        mProfilePicture.layer.borderColor = UIColor.white.cgColor
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let email = Auth.auth().currentUser?.email
        mProfilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleSelectProfileImage)))
        mProfilePicture.isUserInteractionEnabled = true
        
        let docRef = db.collection("users").document(email!);
        
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {return}
            let data = document.data()
            self.mMyName.text = data!["name"] as? String
            self.mMyEmail.text = email
            self.mMyLocation.text = data!["school"] as? String
            let URL = data!["avatar"] as! String
            let httpsReference = storage.reference(forURL: URL)
            httpsReference.getData(maxSize: 10000 * 10000 * 10000){ data, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.mProfilePicture.image? = UIImage(named: "addProfile.png")!
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.mProfilePicture.image = image!
                }
            }
        }
        
    }
    
    @objc func handleSelectProfileImage(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    // initiate the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            mProfilePicture.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    // handle cancelling from image picker and return to previous view
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        let db = Firestore.firestore()
        let email = Auth.auth().currentUser?.email


        let docRef = db.collection("users").document(email!);

        guard let modifyName = mMyName.text, !modifyName.isEmpty else {return}
        guard let modifyLocation = mMyLocation.text, !modifyLocation.isEmpty else {return}
        let dataToSave: [String: Any] = ["name": modifyName, "school": modifyLocation]
        docRef.updateData(dataToSave) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("New profile has been saved!")
            }
        }
        
        let storageRef = Storage.storage().reference()
        let uploadData = UIImagePNGRepresentation(self.mProfilePicture.image!)
        let imagePath = "profileImage/\(self.mMyEmail.text!)/userPic.jpg"
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageRef = storageRef.child(imagePath)
        imageRef.putData(uploadData!, metadata: metadata, completion: {
            (metadata, error) in
            if error != nil {
                print("error")
                return
            }
        })

        let alertController = UIAlertController(title: nil, message: "Your new profile saved!", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)

        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

