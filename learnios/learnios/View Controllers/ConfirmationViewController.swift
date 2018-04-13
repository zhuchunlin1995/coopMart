//
//  ConfirmationViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 4/8/18.
//

import UIKit

protocol ConfirmationViewControllerDelegate : class {
    func didSelectLibrary(confirmationViewController: ConfirmationViewController)
    func didSelectTakePhoto(confirmationViewController: ConfirmationViewController)
    func didSelectPostItem(confirmationViewController: ConfirmationViewController)
}

class ConfirmationViewController: UIViewController {
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var changePhoto: UIButton!
    @IBOutlet weak var usePhoto: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var Name: UITextField!
    var imagePicker: UIImagePickerController!
    var profilesData: [Int]!
    var image: UIImage?
    weak var delegate: ConfirmationViewControllerDelegate?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        Description.textColor = .lightGray
        Description.text = "Description of Your Item"
        self.Description.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPhotoToImageView()
    }
    
    @IBAction func changePhotoButtonTapped(_ sender: UIButton) {
        showPhotoActionSheet()
    }
    
    @IBAction func usePhotoButtonTapped(_ sender: UIButton) {
        if (!ImageUtils.saveCached(image: self.image!, name: self.Name.text?, price: self.price.text?, description: self.Description.text?) || !ImageUtils.saveToPhotosAlbum(image: image)) {
            didNotSaveImage(handler: { (_) in
                self.dismiss(animated: false, completion: {
                    self.imageView.image = nil
                    self.usePhoto.isEnabled = false
                    self.delegate?.didSelectTakePhoto(confirmationViewController: self)
                })
            })
        } else {
            dismiss(animated: false, completion: {
                self.imageView.image = nil
                self.usePhoto.isEnabled = false
                self.delegate?.didSelectTakePhoto(confirmationViewController: self)
            })
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func setPhotoToImageView() {
        guard let photo = image else {
            imageFailedtoPresent()
            return
        }
        let uncroppedImage = photo.rotateUpRightOrientedImage()
        self.imageView.image = uncroppedImage
        
        //ImageUtils.cropToBounds(image: uncroppedImage, width: Double(view.frame.size.width), height: Double(view.frame.size.width))
    }
    
    func imageFailedtoPresent() {
        let alertController = UIAlertController(title: "Something Went Wrong", message: "Your photo seems to be missing. Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func didNotGetImage(error: Error) {
        let alertController = UIAlertController(title: "Something Went Wrong", message: "There was an issue with accessing your photo. Please try again.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func didNotSaveImage(handler: ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: "Something Went Wrong", message: "There was an issue with saving your photo. Please try again.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPhotoActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let LibraryAction = UIAlertAction(title: "Use Existing", style: UIAlertActionStyle.default, handler: goToLibrary)
        let CameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: takePhoto)
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        optionMenu.addAction(LibraryAction)
        optionMenu.addAction(CameraAction)
        optionMenu.addAction(CancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func goToLibrary(alert: UIAlertAction) {
        delegate?.didSelectLibrary(confirmationViewController: self)
    }
    
    func takePhoto(alert: UIAlertAction) {
        delegate?.didSelectTakePhoto(confirmationViewController: self)
    }
}

extension UIImage {
    func rotateUpRightOrientedImage() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let rotateUpRightImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotateUpRightImage
    }
}

extension ConfirmationViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if Description.textColor == .lightGray && Description.isFirstResponder {
            Description.text = nil
            Description.textColor = .black
        }
    }
    func textViewDidEndEditing (_ textView: UITextView) {
        if Description.text.isEmpty || Description.text == "" {
            Description.textColor = .lightGray
            Description.text = "Description of Your Item"
        }
    }
}
