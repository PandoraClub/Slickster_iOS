//
//  SignUpViewController.swift
//  Slickster
//
//  Created by NonGT on 10/4/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class SignUpViewController : PFSignUpViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.signUpView!.backgroundColor = UIColor.blackColor()
        self.signUpView!.logo = UIImageView(image: UIImage(named:"logo-text.png"))
        self.signUpView!.logo?.contentMode = .ScaleAspectFit
        
        self.signUpView!.usernameField?.backgroundColor = UIColor.blackColor()
        self.signUpView!.usernameField?.textColor = UIColor.whiteColor()
        
        self.signUpView!.usernameField?.layer.cornerRadius = 8.0
        self.signUpView!.usernameField?.layer.masksToBounds = true
        self.signUpView!.usernameField?.layer.borderColor = UIColor(rgb: 0x136066).CGColor
        self.signUpView!.usernameField?.layer.borderWidth = 1.5
        
        self.signUpView!.passwordField?.backgroundColor = UIColor.blackColor()
        self.signUpView!.passwordField?.textColor = UIColor.whiteColor()
        
        self.signUpView!.passwordField?.layer.cornerRadius = 8.0
        self.signUpView!.passwordField?.layer.masksToBounds = true
        self.signUpView!.passwordField?.layer.borderColor = UIColor(rgb: 0x136066).CGColor
        self.signUpView!.passwordField?.layer.borderWidth = 1.5

        self.signUpView!.emailField?.backgroundColor = UIColor.blackColor()
        self.signUpView!.emailField?.textColor = UIColor.whiteColor()

        self.signUpView!.emailField?.layer.cornerRadius = 8.0
        self.signUpView!.emailField?.layer.masksToBounds = true
        self.signUpView!.emailField?.layer.borderColor = UIColor(rgb: 0x136066).CGColor
        self.signUpView!.emailField?.layer.borderWidth = 1.5
        
        self.signUpView!.signUpButton?.setBackgroundImage(
            UIImage(named: "button-bg-dark.png"), forState: .Normal)
        
        self.signUpView!.signUpButton?.layer.cornerRadius = 8.0
        self.signUpView!.signUpButton?.layer.masksToBounds = true
        self.signUpView!.signUpButton?.layer.borderColor = UIColor(rgb: 0x58D2DE).CGColor
        self.signUpView!.signUpButton?.layer.borderWidth = 1.2
        self.signUpView!.signUpButton?.layer.borderWidth = 1.2
        
        UITextField.appearance().tintColor = UIColor(rgb: 0x58D2DE)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let of = self.signUpView!.frame
        
        let lof = self.signUpView!.logo!.frame
        self.signUpView!.logo!.frame = CGRectMake(
            lof.origin.x, lof.origin.y, lof.size.width, 40.0)
        
        let uof = self.signUpView!.usernameField!.frame
        self.signUpView!.usernameField!.frame = CGRectMake(
            20, uof.origin.y, of.size.width - 40, uof.size.height)
        
        let pof = self.signUpView!.passwordField!.frame
        self.signUpView!.passwordField!.frame = CGRectMake(
            20, pof.origin.y + 5, of.size.width - 40, pof.size.height)

        let eof = self.signUpView!.emailField!.frame
        self.signUpView!.emailField!.frame = CGRectMake(
            20, eof.origin.y + 10, of.size.width - 40, eof.size.height)
        
        let bof = self.signUpView!.signUpButton!.frame
        self.signUpView!.signUpButton!.frame = CGRectMake(
            20, bof.origin.y + 5, of.size.width - 40, pof.size.height)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}