//
//  ChangePasswordViewController.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/17/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    @IBOutlet weak var activeText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let textFields = [newPasswordField, confirmNewPasswordField]
        
        for textField in textFields {
            
            textField.attributedPlaceholder = NSAttributedString(
                string: textField.placeholder!,
                attributes:[NSForegroundColorAttributeName:
                    UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)])
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ChangePasswordViewController.keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ChangePasswordViewController.keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backActivated(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func saveActivated(sender: AnyObject) {
        
        if newPasswordField.text == "" {
            
            let alert = UIAlertController(
                title: "Message",
                message: "Password cannot be blank", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if newPasswordField.text != confirmNewPasswordField.text {
            
            let alert = UIAlertController(
                title: "Message",
                message: "Password do not match.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SVProgressHUD.showWithStatus("Saving ...")
        
        PFUser.currentUser()?.password = newPasswordField.text
        
        PFUser.currentUser()?.saveInBackgroundWithBlock() {
            (result, error) in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
                
                let alert = UIAlertController(
                    title: "Error",
                    message: error?.localizedDescription, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alert.addAction(OKAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeText = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeText = nil
    }
    
    func keyboardWillShow(note: NSNotification) {
        
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            scrollView.contentInset.bottom = keyboardSize.height
            
            if activeText != nil {
                let rect = scrollView.convertRect(activeText.bounds, fromView: activeText)
                scrollView.scrollRectToVisible(rect, animated: false)
            }
            
            UIView.commitAnimations()
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        
        scrollView.contentInset.bottom = 0
        UIView.commitAnimations()
    }
}
