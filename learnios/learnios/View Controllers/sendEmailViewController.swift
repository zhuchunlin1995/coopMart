//
//  sendEmailViewController.swift
//  learnios
//
//  Created by 万琳莉 on 23/04/2018.
//

import UIKit
import Foundation
import MessageUI

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController : MFMailComposeViewControllerDelegate {
    
    func configuredMailComposeViewController(recipients : [String]?, subject :
        String, body : String, isHtml : Bool = false,
                images : [UIImage]?) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // IMPORTANT
        
        mailComposerVC.setToRecipients(recipients)
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: isHtml)
        
        for img in images ?? [] {
            if let jpegData = UIImageJPEGRepresentation(img, 1.0) {
                mailComposerVC.addAttachmentData(jpegData,
                                                 mimeType: "image/jpg",
                                                 fileName: "Image")
            }
        }
        
        return mailComposerVC
    }
    
    func presentMailComposeViewController(mailComposeViewController :
        MFMailComposeViewController) {
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController,
                         animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController.init(title: "Error",
                                                            message: "Unable to send email. Please check your email " +
                "settings and try again.", preferredStyle: .alert)
            self.present(sendMailErrorAlert, animated: true,
                         completion: nil)
        }
    }
    
    public func mailComposeController(controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        switch (result) {
        case .cancelled:
            self.dismiss(animated: true, completion: nil)
        case .sent:
            self.dismiss(animated: true, completion: nil)
        case .failed:
            self.dismiss(animated: true, completion: {
                let sendMailErrorAlert = UIAlertController.init(title: "Failed",
                                                                message: "Unable to send email. Please check your email " +
                    "settings and try again.", preferredStyle: .alert)
                sendMailErrorAlert.addAction(UIAlertAction.init(title: "OK",
                                                                style: .default, handler: nil))
                self.present(sendMailErrorAlert,
                             animated: true, completion: nil)
            })
        default:
            break;
        }
    }
    
    func versionText () -> String {
        let bundleVersionKey = "CFBundleShortVersionString"
        let buildVersionKey = "CFBundleVersion"
        
        if let version = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) {
            if let build = Bundle.main.object(forInfoDictionaryKey: buildVersionKey) {
                let version = "Version \(version) - Build \(build)"
                return version
            }
        }
        
        return ""
    }
}




class sendEmailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBtnEmail(sender: AnyObject) {
//        let toRecipients = ["Wanlinli1995@gmail.com"]
//        let subject = "Feedback"
//        let body = "Enter comments here...<br><br><p>I have a \(versionText()).<br> And iOS version \(UIDevice.current.systemVersion).<br</p>"
//        let mail = configuredMailComposeViewController(recipients: toRecipients, subject: subject, body: body, isHtml: true, images: nil)
//        presentMailComposeViewController(mailComposeViewController: mail)
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["address@example.com"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("Hello from California!", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
    }
    

    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }


}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//
//}

