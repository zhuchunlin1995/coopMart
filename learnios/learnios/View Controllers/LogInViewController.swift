//
//  LogInViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 3/20/18.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class LoginController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // restrict to only portrait version on iphone devices
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    // forbid rotation
    override var shouldAutorotate: Bool {
        return false
    }
    
    // instantiate a inputs container view
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    // instantiate a button for login or register
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 236, g: 22, b: 22)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        // add action for button
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    
    // handle the switch between login and register and call helper method respectively
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            _ = handleLogin(test: false)
        } else {
            _ = handleRegister(test: false)
        }
    }
    
    func handleLogin(test : Bool) -> String {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            return "fail"
        } else {
            var result = ""
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                    result = "success"
                    
                 } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    result = "failure"
                }
            }
            return result
        }
    }
    
    func handleRegister(test : Bool) -> String {
        var result = ""
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if error == nil {
                
                //upload profile picture
                let storageRef = Storage.storage().reference()
                let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
                let imagePath = "profileImage/\(self.emailTextField.text!)/userPic.jpg"
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
            
                
                // upload baisc user infor to database
                let db = Firestore.firestore();
                let cartLists: [String: Any] = [
                    "name":"new name",
                    "description": "new discription",
                    "price": "new price",
                    "email": "seller's email"
                ]
                db.collection("users").document(self.emailTextField.text!).setData([
                    "name":self.nameTextField.text!,
                    "avatar":"gs://coopmart-1f06f.appspot.com/\(imageRef.fullPath)",
                    "school": "null",
//                    "cart lists": [
//                        cartLists
//                    ]
                    ])
                
                print("You have successfully signed up")
                //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as! UITabBarController
                self.present(vc, animated: true, completion: nil)
                result = "success"
                
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                result = "failure"
            }
        }
        return result
    }
    
    // instantiate components in the input container : name textbox
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name: John Dough"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    // instantiate components in the input container : separator
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // instantiate components in the input container : email textbox
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address: jd2920@columbia.edu"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    // instantiate components in the input container : separator
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // instantiate components in the input container : password textbox
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()

    // "let" is substituted by "lazy var" for access to using "self" in addGestureRecognizer
     lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addProfile.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        //this should be added to the image where user should click to add profile image
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleSelectProfileImage)))
        imageView.isUserInteractionEnabled = true
        //when log in, stay transparent
        imageView.alpha = 0.0
        return imageView
    }()
    
    // logo of AcquainTest header
    lazy var logoHeaderView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "profilePageLogo")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.contentMode = .scaleAspectFill
        
        return logoView
    }()
    
    // switch between login and register
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        let titleTextAttributes = [kCTForegroundColorAttributeName: UIColor.black]
        sc.setTitleTextAttributes(titleTextAttributes, for: .selected)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.red
        sc.backgroundColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    // helper function that handle the changes in login page view between login and register.
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        
        loginRegisterButton.setTitle(title, for: .normal)
        
        // make profile placeholder appear
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 1, delay: 0.5, animations: {
                self.profileImageView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.8, delay: 0.0, animations: {
                self.profileImageView.alpha = 0.0
            })
        }
        
        // change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100:150
        
        //change height of text fields inside inputContainerView
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2:1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2:1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 1, animations: {
                let trans = CGAffineTransform(translationX: 0, y: -85)
                let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.logoHeaderView.transform = trans.concatenating(scale)
            })
        } else {
            UIView.animate(withDuration: 0.8, delay: 0.3, animations: {
                let trans = CGAffineTransform(translationX: 0, y: 0)
                let scale = CGAffineTransform.identity
                self.logoHeaderView.transform = trans.concatenating(scale)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackground()
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(logoHeaderView)
        
        setupInputsContainterView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupLogoHeaderView()
    }
    
    func assignBackground(){
        let background = UIImage(named: "Pattern")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    
    func setupLoginRegisterSegmentedControl() {
        // Need x, y, width and height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        //loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    // keep a reference to the attributes of this class
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var logoHeaderViewTopAnchor: NSLayoutConstraint?
    
    func setupLogoHeaderView() {
        // Need x, y, width and height constraints
        logoHeaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let logoHeaderViewTopHeader = logoHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        logoHeaderViewTopHeader.isActive = true
        logoHeaderView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoHeaderView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupInputsContainterView() {
        // Need x, y, width and height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 12).isActive = true
        //inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // Need x, y, width and height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = true
        
        // Need x, y, width and height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Need x, y, width and height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Need x, y, width and height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Need x, y, width and height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        // Need x, y, width and height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupProfileImageView() {
        // Need x, y, width and height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        //set the profile to a circle
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.clipsToBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // handler to present image picker to select image for profile image
    @objc func handleSelectProfileImage() {
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
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    // handle cancelling from image picker and return to previous view
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// helper which allows easier setup of UIColor
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
