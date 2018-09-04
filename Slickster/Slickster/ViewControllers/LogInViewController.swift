//
//  LoginViewController.swift
//  Slickster
//
//  Created by NonGT on 10/4/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import QuartzCore

class LogInViewController : PFLogInViewController {
    
    private var googlePlusButton: UIButton?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.logInView!.hidden = true
        
        self.logInView!.backgroundColor = UIColor.blackColor()
        self.logInView!.logo = UIImageView(image: UIImage(named:"logo-text-sm.png"))
        self.logInView!.logo?.contentMode = .ScaleAspectFit
        
        self.logInView!.usernameField?.backgroundColor = UIColor.blackColor()
        self.logInView!.usernameField?.textColor = UIColor.whiteColor()
        
        self.logInView!.usernameField?.layer.cornerRadius = 8.0
        self.logInView!.usernameField?.layer.masksToBounds = true
        self.logInView!.usernameField?.layer.borderColor = UIColor(rgb: 0x136066).CGColor
        self.logInView!.usernameField?.layer.borderWidth = 1.5
        
        self.logInView!.passwordField?.backgroundColor = UIColor.blackColor()
        self.logInView!.passwordField?.textColor = UIColor.whiteColor()
        
        self.logInView!.passwordField?.layer.cornerRadius = 8.0
        self.logInView!.passwordField?.layer.masksToBounds = true
        self.logInView!.passwordField?.layer.borderColor = UIColor(rgb: 0x136066).CGColor
        self.logInView!.passwordField?.layer.borderWidth = 1.5
        
        self.logInView!.logInButton?.setBackgroundImage(
            UIImage(named: "button-bg-dark.png"), forState: .Normal)
            
        self.logInView!.logInButton?.layer.cornerRadius = 8.0
        self.logInView!.logInButton?.layer.masksToBounds = true
        self.logInView!.logInButton?.layer.borderColor = UIColor(rgb: 0x58D2DE).CGColor
        self.logInView!.logInButton?.layer.borderWidth = 1.2
        
        initGoogleSignIn()
        
        UITextField.appearance().tintColor = UIColor(rgb: 0x58D2DE)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        NSTimer.scheduledTimerWithTimeInterval(
            0.1, target: self,
            selector: #selector(LogInViewController.show),
            userInfo: nil, repeats: false)
    }
    
    func show() {
        
        self.logInView!.hidden = false
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let of = self.logInView!.frame
        
        let lof = self.logInView!.logo!.frame
        self.logInView!.logo!.frame = CGRectMake(
            lof.origin.x, lof.origin.y, lof.size.width, 40.0)
        
        let uof = self.logInView!.usernameField!.frame
        self.logInView!.usernameField!.frame = CGRectMake(
            20, uof.origin.y, of.size.width - 40, uof.size.height)
        
        let pof = self.logInView!.passwordField!.frame
        self.logInView!.passwordField!.frame = CGRectMake(
            20, pof.origin.y + 5, of.size.width - 40, pof.size.height)
        
        let bof = self.logInView!.logInButton!.frame
        self.logInView!.logInButton!.frame = CGRectMake(
            20, bof.origin.y, of.size.width - 40, pof.size.height)

        // Custom Facebook Login Button
        self.logInView!.facebookButton?.frame = CGRectMake(
            (self.logInView!.facebookButton?.frame.origin.x)!,
            (self.logInView!.facebookButton?.frame.origin.y)!,
            (self.logInView!.frame.width) / 2 - 20,
            (self.logInView!.facebookButton?.frame.height)!)

        self.logInView!.facebookButton?.setTitle("Facebook", forState: .Normal)

        // Custom Google+ Login Button
        self.googlePlusButton!.frame = CGRectMake(
            (self.logInView!.frame.width) / 2 + 5,
            (self.logInView!.facebookButton?.frame.origin.y)!,
            (self.logInView!.frame.width) / 2 - 20,
            (self.logInView!.facebookButton?.frame.height)!)
        
        self.googlePlusButton!.titleEdgeInsets = UIEdgeInsetsMake(0.0, -860.0, 0.0, 0.0)
        self.googlePlusButton!.imageEdgeInsets =
            UIEdgeInsetsMake(0.0, 0, 0.0, self.googlePlusButton!.bounds.width / 2 + 35)
    }
    
    func googleLoginActivated(sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}

extension LogInViewController : GIDSignInUIDelegate {
    
    func initGoogleSignIn() {
        
        // Custom Google+ Login Button
        let googlePlusLoginTitle = "Google+"
        
        let googlePlusLoginTitleAttributed =
        NSMutableAttributedString(
            string: googlePlusLoginTitle,
            attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 16.00)!])
        
        googlePlusLoginTitleAttributed.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0xffffff),
            range: NSRange(location: 0, length: googlePlusLoginTitle.characters.count))
        
        self.googlePlusButton = UIButton()
        self.googlePlusButton!.layer.cornerRadius = 5
        self.googlePlusButton!.layer.masksToBounds = true
        self.googlePlusButton!.setBackgroundImage(UIImage(named: "button-bg-google.png"), forState: .Normal)
        
        self.googlePlusButton!.imageView!.contentMode = .ScaleAspectFit
        self.googlePlusButton!.imageView!.layer.minificationFilter = kCAFilterTrilinear
        self.googlePlusButton!.setImage(UIImage(named: "googleplus-logo.png"), forState: .Normal)
        
        self.googlePlusButton!.titleLabel!.contentMode = .Center
        self.googlePlusButton!.setAttributedTitle(googlePlusLoginTitleAttributed, forState: .Normal)
        self.logInView!.addSubview(self.googlePlusButton!)
        
        self.logInView!.passwordForgottenButton?.setTitleColor(UIColor(rgb: 0x136066), forState: .Normal)
        
        self.googlePlusButton!.addTarget(self,
            action: #selector(LogInViewController.googleLoginActivated(_:)),
            forControlEvents: UIControlEvents.TouchUpInside)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
}