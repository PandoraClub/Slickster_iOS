//
//  ProfileViewController.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/12/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
import DBCamera
import SVProgressHUD
import QBImagePickerController
import Photos

class ProfileViewController: UIViewController, UITextFieldDelegate, UIActionSheetDelegate {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var streetLine1: UITextField!
    @IBOutlet weak var streetLine2: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var myInterestsButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activeText: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    private var isUserProfileLoaded = false
    private var isLoadingUserProfileData = false
    private var unsavedProfileImage: UIImage? = nil
    private var selectedCountryCode: String? = nil
    
    private let transitionManager = TransitionManager(useScreenSize: true, duration: 0.3)

    let countryPicker = CountrySelectionViewController()
    
    convenience init() {
        
        self.init(nibName: "ProfileViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.unsavedProfileImage = nil

        self.profileImageButton.layer.borderColor = UIColor(rgb: 0x00BBBC).CGColor
        self.profileImageButton.layer.borderWidth = 2.0
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.bounds.size.width * 0.5
        self.profileImageButton.layer.masksToBounds = true
        self.profileImageButton.setTitle("", forState: .Normal)
        
        self.countryButton.layer.cornerRadius = 5
        self.countryButton.layer.masksToBounds = true
        
        self.myInterestsButton.layer.cornerRadius = 5
        self.myInterestsButton.layer.masksToBounds = true
        self.myInterestsButton.layer.borderColor = UIColor(rgb: 0x00BBBC).CGColor
        self.myInterestsButton.layer.borderWidth = 2.0
        
        self.changePasswordButton.layer.cornerRadius = 5
        self.changePasswordButton.layer.masksToBounds = true
        self.changePasswordButton.layer.borderColor = UIColor(rgb: 0x00BBBC).CGColor
        self.changePasswordButton.layer.borderWidth = 2.0
        self.changePasswordButton.hidden = true
        
        let textFields = [
            displayNameField, streetLine1, streetLine2,
            cityTextField, stateTextField, zipTextField]
        
        for textField in textFields {
            
            textField.attributedPlaceholder = NSAttributedString(
                string: textField.placeholder!,
                attributes:[NSForegroundColorAttributeName:
                    UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)])
        }
        
        loadProfileData()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ProfileViewController.keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ProfileViewController.keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        loadProfileData()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func countryActivated(sender: AnyObject) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        countryPicker.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)

        countryPicker.delegate = self
        countryPicker.selectedCountry = selectedCountryCode
        self.presentViewController(countryPicker, animated: true, completion: nil)
    }
    
    @IBAction func changePasswordActivated(sender: AnyObject) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let changePasswordViewController = ChangePasswordViewController()
        
        changePasswordViewController.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        changePasswordViewController.transitioningDelegate = transitionManager
        self.presentViewController(changePasswordViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveActivated(sender: AnyObject) {
        
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SVProgressHUD.showWithStatus("Saving ...")
        
        let saveProfilePicture = { (callback: (imageFile: PFFile?) -> Void) -> Void in
            
            if self.unsavedProfileImage != nil {
                
                let data = UIImageJPEGRepresentation(self.unsavedProfileImage!, 0.5)
                let imageFile = PFFile(name: "userimage.jpg", data: data!)
                
                imageFile?.saveInBackgroundWithBlock({ succeed in
                    
                    UserManager.sharedInstance.updateUserPicture(
                        PFUser.currentUser()!, picture: imageFile!,
                        callback: { result in
                            
                            callback(imageFile: imageFile)
                        })
                })
                
                self.unsavedProfileImage = nil
                
            } else {
                
                callback(imageFile: nil)
            }
        }
        
        saveProfilePicture() { imageFile in
            
            UserManager.sharedInstance.ensureUserDetails(PFUser.currentUser()!, callback:
                { (userDetails: UserDetails?, error: NSError?) -> Void in
                
                if imageFile != nil {
                    userDetails!.userPicture = imageFile!
                    UserManager.sharedInstance.needUserPictureRefresh = true
                }
                
                userDetails!.displayName = self.displayNameField.text
                userDetails!.addressLine1 = self.streetLine1.text
                userDetails!.addressLine2 = self.streetLine2.text
                userDetails!.city = self.cityTextField.text
                userDetails!.state = self.stateTextField.text
                userDetails!.zipCode = self.zipTextField.text
                userDetails!.country = self.selectedCountryCode
                userDetails!.saveEventually()
                    
                SVProgressHUD.dismiss()
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    @IBAction func backActivated(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func profileImageButtonActivated(sender: AnyObject) {
        
        //Create the AlertController
        let actionSheetController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action -> Void in
            //Just dismiss the action sheet
        }
        
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) {
            action -> Void in
            
            self.takePictureForProfile()
        }
        
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            
            self.browseCameraRoll()
        }

        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(takePictureAction)
        actionSheetController.addAction(choosePictureAction)

        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func myInterestsButtonActivated(sender: AnyObject) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let interestsSelectionViewController = InterestSelectionGridViewController()
        
        interestsSelectionViewController.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        interestsSelectionViewController.transitioningDelegate = transitionManager
        
        if !UserInterestManager.sharedInstance.isLoaded() {
            
            SVProgressHUD.setBackgroundColor(UIColor.blackColor())
            SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
            SVProgressHUD.setDefaultMaskType(.Gradient)
            SVProgressHUD.showWithStatus("Loading ...")
            
            UserInterestManager.sharedInstance.ensureUserInterests(PFUser.currentUser()!) {
                (userInterests, error) -> Void in
                
                SVProgressHUD.dismiss()
                
                self.presentViewController(interestsSelectionViewController, animated: true, completion: nil)
            }
            
        } else {
            
            self.presentViewController(interestsSelectionViewController, animated: true, completion: nil)
        }
    }
    
    func browseCameraRoll() {

        let imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsMultipleSelection = false
        imagePickerController.mediaType = .Image
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func takePictureForProfile() {
        
        let cameraViewController = DBCameraViewController.initWithDelegate(self)
        cameraViewController.useCameraSegue = false
        
        let cameraContainer = DBCameraContainerViewController.init(delegate: self, cameraSettingsBlock: {
            
            (cameraView:DBCameraView!, container:AnyObject!) in
            cameraView.photoLibraryButton.hidden = true
        })
        
        cameraContainer.cameraViewController = cameraViewController
        
        self.presentViewController(cameraContainer, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeText = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeText = nil
    }
    
    func loadProfileData() {
        
        if isUserProfileLoaded {
            
            return
        }
        
        if isLoadingUserProfileData {
            
            return
        }
        
        isLoadingUserProfileData = true
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.center = CGPointMake(
            profileImageButton.bounds.width / 2.0,
            profileImageButton.bounds.height / 2.0)
        
        indicator.frame = CGRectMake(0, 0,
            profileImageButton.bounds.width,
            profileImageButton.bounds.height)
        
        profileImageButton.addSubview(indicator)
        indicator.startAnimating()
        
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            UserManager.sharedInstance.ensureUserDetails(PFUser.currentUser()!) {
                (userDetails: UserDetails?, error: NSError?) in
                
                if userDetails == nil {
                    
                    return
                }
                
                if userDetails!.type == "registered" {
                    
                    self.changePasswordButton.hidden = false
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.displayNameField.text = userDetails?.displayName
                    
                    // If userDetails.userPicture is nil, use UserManager to acquire profile image.
                    if(userDetails?.userPicture == nil) {
                        
                        UserManager.sharedInstance.resolveImage(userDetails!, callback: {
                            (image: UIImage?, error: NSError?) -> Void in
                            
                            indicator.stopAnimating()
                            indicator.removeFromSuperview()
                            
                            if image != nil {
                                
                                let pic = RBSquareImageTo(image!, size: CGSizeMake(100, 100))
                                self.profileImageButton.setImage(pic, forState: .Normal)
                                
                            } else {
                                
                                self.clearProfileImage()
                            }
                        })
                        
                    } else {
                        
                        userDetails?.userPicture?.getDataInBackgroundWithBlock({ (data, error) in
                            
                            indicator.stopAnimating()
                            indicator.removeFromSuperview()

                            if (error == nil) {
                                
                                let image = UIImage(data: data!)
                                
                                let pic = RBSquareImageTo(image!, size: CGSizeMake(100, 100))
                                self.profileImageButton.setImage(pic, forState: .Normal)
                            }
                        })
                    }
                    
                    self.displayNameField.text = userDetails!.displayName
                    self.streetLine1.text = userDetails!.addressLine1
                    self.streetLine2.text = userDetails!.addressLine2
                    self.cityTextField.text = userDetails!.city
                    self.stateTextField.text = userDetails!.state
                    self.zipTextField.text = userDetails!.zipCode
                    self.selectedCountryCode = userDetails!.country
                    
                    let locale = NSLocale.currentLocale()
                    
                    if self.selectedCountryCode == nil {
                        
                        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
                        let countryName = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
                        
                        self.countryButton.setTitle(countryName, forState: .Normal)
                        
                    } else {
                        
                        let countryCode = self.selectedCountryCode!
                        let countryName = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
                        
                        self.countryButton.setTitle(countryName, forState: .Normal)
                    }
                    
                    self.isUserProfileLoaded = true
                })
                
                self.isLoadingUserProfileData = false
            }
        }
    }
    
    private func clearProfileImage() {
        
        let thumb = RBSquareImageTo(UIImage(named: "blank-user")!, size: CGSizeMake(100, 100))
        profileImageButton.setImage(thumb, forState: .Normal)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
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
    
    func setUserImage(image: UIImage!) {
        
        unsavedProfileImage = image;

        let pic = RBSquareImageTo(image!, size: CGSizeMake(100, 100))
        self.profileImageButton.setImage(pic, forState: .Normal)
    }
}

extension ProfileViewController : DBCameraViewControllerDelegate {
    
    func camera(cameraViewController: AnyObject!,
        didFinishWithImage image: UIImage!, withMetadata metadata: [NSObject : AnyObject]!) {
            
        setUserImage(image)
            
        cameraViewController.dismissViewControllerAnimated(true, completion: {})
    }
    
    func dismissCamera(cameraViewController: AnyObject!) {
        
        cameraViewController.dismissViewControllerAnimated(true, completion: {})
    }
}

extension ProfileViewController : QBImagePickerControllerDelegate {
    
    func qb_imagePickerController(imagePickerController:
        QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
            
        let asset = assets.first as? PHAsset
            
        let manager = PHImageManager.defaultManager()
        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        options.synchronous = true
        options.networkAccessAllowed = true
            
        manager.requestImageDataForAsset(asset!, options: options) {
            (data, dataUTI, orientation, info) -> Void in
            
            let image = UIImage(data: data!)
            self.setUserImage(image)
        }
            
        imagePickerController.dismissViewControllerAnimated(true, completion: {})
    }
}

extension ProfileViewController : CountrySelectionViewControllerDelegate {
    
    func countrySelectionViewController(sender: AnyObject!, didSelectCountry countryCode: String!) {
        
        let locale = NSLocale.currentLocale()
        
        let countryCode = countryCode
        let countryName = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
        
        self.countryButton.setTitle(countryName, forState: .Normal)
        self.selectedCountryCode = countryCode
        
        countryPicker.dismissViewControllerAnimated(true, completion: {})
    }
}