//
//  UserManager.swift
//  Slickster
//
//  Created by NonGT on 10/14/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit

class UserManager: NSObject {

    static var sharedInstance = UserManager()
    
    private var userDetails: UserDetails?
    
    var needUserPictureRefresh: Bool = false
    
    func resolveImage(userDetails: UserDetails, callback: (UIImage?, NSError?) -> Void) {
        
        print("resolveImage type: \(userDetails.type!)")
        
        if(userDetails.type == "facebook") {
            
            let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                let account = userDetails.linkedAccounts!.filter {
                    acc in
                    
                    let a = try? acc.fetchIfNeeded()
                    return a!.type == "facebook"
                    
                    }.first
                
                if account != nil {
                    
                    let imgURL: NSURL = NSURL(
                        string: "https://graph.facebook.com/\(account!.accountId!)/picture?type=large"
                        )!
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    
                    let session = NSURLSession.sharedSession()
                    let task = session.dataTaskWithRequest(request) {
                        (data, response, error) -> Void in
                        
                        if (error == nil && data != nil) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                callback(UIImage(data: data!), error)
                            })
                        }
                    }
                    
                    task.resume()
                    
                    return
                }
                
                // If do not found associated account, just return nil
                dispatch_async(dispatch_get_main_queue()) {
                    
                    callback(nil, nil)
                }
            }
            
            return
        }
        
        if(userDetails.type == "google") {
            
            let imgURL = NSURL(string: userDetails.pictureUrl!)
            
            if(imgURL == nil) {
                
                callback(nil, nil)
                return
            }
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                
                if (error == nil && data != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        callback(UIImage(data: data!), error)
                    })
                }
            }
            
            task.resume()
            
            return
        }
        
        callback(nil, nil)
    }
    
    func cleanupLocalData(user: PFUser) {

        if userDetails?.type == "facebook" {
            
            // Still have no way to sign out.
        }
        
        if userDetails?.type == "google" {
            
            print("Sign out google")
            GIDSignIn.sharedInstance().signOut()
        }

        self.userDetails = nil
        
        getStoredUserDetails(user) {
            (userDetails: UserDetails?, error: NSError?) in
            
            if(userDetails != nil) {
                
                print("unpin user in background")
                user.unpinInBackground()
            }
        }
    }
    
    func create3rdParseUser(
        userId: String, token: String,
        name: String, email: String,
        imageUrl: NSURL?, service: String,
        callback: (PFUser?, NSError?) -> Void) {
        
        let user = PFUser()
        user.username = userId
        user.password = Config.parse.secret3rdPassword
        user.email = email
        
        let authDataString =
            "{\"\(service)\":{\"access_token\":\"\(token)\",\"id\":\"\(userId)\"}}"
        
        user["authDataThirdParty"] = authDataString
        
        user.signUpInBackgroundWithBlock({ (result, error) -> Void in
            
            if error == nil {
                
                print("Prepare to create UserDetails")
                print("imageUrl: \(imageUrl)")
                
                let userDetails = UserDetails()
                
                userDetails.type = service
                userDetails.username = user.username
                
                if imageUrl != nil {
                    userDetails.pictureUrl = imageUrl!.absoluteString
                }
                
                let gp = UserAccount()
                gp.accountId = user.username
                gp.type = service
                
                userDetails.displayName = name
                userDetails.linkedAccounts = [UserAccount]()
                userDetails.linkedAccounts!.append(gp);
                
                print("Saving new 3rd party Parse User")
                self.saveParseUserDetails(userDetails, callback: {
                    (err) in
                    
                    if(err != nil) {
                
                        print("Saving error")
                        callback(nil, err)
                        
                    } else {
                        
                        print("Saving success")
                        callback(user, nil)
                    }
                    
                })
                
            } else {
                
                callback(nil, error)
            }
        })
    }
    
    func updateUserPicture(user: PFUser, picture: PFFile, callback: (Bool) -> Void) {
        
        ensureUserDetails(user) {
            (userDetails: UserDetails?, error: NSError?) in
        
            userDetails!.userPicture = picture
            userDetails!.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) in
                
                callback(result)
            })
        }
    }
    
    func ensureUserDetails(user: PFUser, callback: (UserDetails?, NSError?) -> Void) {
        
        if self.userDetails != nil {
            
            print("found cached user!")
         
            callback(self.userDetails, nil)
            return
        }
        
        print("getStoredUserDetails (local)...")
        
        getStoredUserDetails(user) {
            (userDetails: UserDetails?, error: NSError?) in
            
            // If error, just callback with error.
            if(error != nil) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    print("getStoredUserDetails (local) error: \(error)")
                    callback(nil, error)
                })
                    
                return
            }
            
            // If userDetails presented, just callback with userDetails.
            if(userDetails != nil) {

                self.ensureUserDetailsIsRecentVersion(userDetails!)
                dispatch_async(dispatch_get_main_queue(), {
                    
                    print("getStoredUserDetails (local) succeed: \(userDetails)")
                    callback(userDetails, nil)
                })
                
                return
            }
            
            print("getStoredUserDetails (local) got nil, proceed...")
            
            // If userDetails still nil but without error, proceed to get the user details.
            self.proceedGetRemoteUserDetails(user, callback: callback)
        }
    }
    
    private func proceedGetRemoteUserDetails(user: PFUser, callback: (UserDetails?, NSError?) -> Void) {
        
        print("getStoredUserDetails (remote)...")
    
        getStoredUserDetails(user, remote: true) { (userDetails: UserDetails?, error: NSError?) in
            
            // If error, just callback with error.
            if(error != nil) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    print("getStoredUserDetails (remote) error: \(error)")
                    callback(nil, error)
                })
                
                return
            }
            
            // If userDetails presented, just callback with userDetails.
            if(userDetails != nil) {
                
                self.ensureUserDetailsIsRecentVersion(userDetails!)
                dispatch_async(dispatch_get_main_queue(), {
                    
                    print("getStoredUserDetails (remote) succeed: \(userDetails)")
                    callback(userDetails, nil)
                })
                
                return
            }
            
            print("getStoredUserDetails (remote) got nil, proceed...")
            
            // If userDetails still nil but without error, proceed to acquire the user details.
            self.proceedEnsureUserDetails(user, callback: callback)
        }
    }
    
    private func proceedEnsureUserDetails(user: PFUser, callback: (UserDetails?, NSError?) -> Void) {
        
        print("proceedEnsureUserDetails...")
        
        let userDetails = UserDetails()
        userDetails.username = user.username
        userDetails.linkedAccounts = [UserAccount]()
        
        // If facebook user, findout display name.
        let isFacebookUser = PFFacebookUtils.isLinkedWithUser(user)
        if(isFacebookUser) {
            
            print("user is Facebook!")
            userDetails.type = "facebook"
            
            let request = FBSDKGraphRequest.init(
                graphPath: "me",
                parameters: ["fields": "id, name, email"])
            
            print("start Facebook acquiring")
            
            dispatch_async(dispatch_get_main_queue(), {
                
                request.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if (error == nil) {
                        
                        print("proceedEnsureUserDetails succeed: \(result)")
                        
                        let fb = UserAccount()
                        fb.accountId = result.valueForKey("id") as? String
                        fb.type = "facebook"
                        
                        userDetails.displayName = result.valueForKey("name") as? String
                        userDetails.linkedAccounts!.append(fb);
                        self.saveParseUserDetails(userDetails)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            callback(userDetails, nil)
                        })
                        
                    } else {
                        
                        print("proceedEnsureUserDetails error: \(error)")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            callback(nil, error)
                        })
                    }
                })
            })
            
            return
        }
        
        // If facebook user, findout display name.
        let isGoogleUser = ThirdPartyUtils.isGoogleUser(user)
        if(isGoogleUser) {
            
            print("user is Google!")
            
            return
        }
        
        // If not fall to any cases above, just mark it as registered user.
        
        print("proceedEnsureUserDetails fallback: registered")
        
        userDetails.type = "registered"
        userDetails.displayName = user.username
        
        self.saveParseUserDetails(userDetails)
        
        dispatch_async(dispatch_get_main_queue(), {
            callback(userDetails, nil)
        })
    }
    
    private func ensureUserDetailsIsRecentVersion(userDetails: UserDetails) {
    
        if(userDetails.dataVersion == nil ||
            userDetails.dataVersion < UserDetails.parseDataVersion()) {
            
            userDetails.dataVersion = UserDetails.parseDataVersion()
        }
        
        self.saveParseUserDetails(userDetails)
    }
    
    private func saveParseUserDetails(userDetails: UserDetails) {
        
        self.userDetails = userDetails;
        
        //userDetails.pinInBackground()
        userDetails.saveEventually()
    }

    private func saveParseUserDetails(userDetails: UserDetails, callback: (error: NSError?) -> Void) {
        
        self.userDetails = userDetails;
        
        //userDetails.pinInBackground()
        userDetails.saveInBackgroundWithBlock({ (result, error) in
            
            if error != nil {
            
                callback(error: error!)
                
            } else {
                
                callback(error: nil)
            }
        })
    }

    private func getStoredUserDetails(
        user: PFUser, remote: Bool = false, callback: (UserDetails?, NSError?) -> Void) {
        
        let query = PFQuery(className: UserDetails.parseClassName())
            
        if(!remote) {
            query.fromLocalDatastore()
        }
            
        print(user.username)
            
        query.whereKey("username", equalTo: user.username!)
        query.findObjectsInBackground().continueWithBlock {
            (task: BFTask!) -> AnyObject in
            
            if(task.error != nil) {
                
                callback(nil, task.error)
                return task
            }
            
            let results = task.result as! [UserDetails]
            let userDetails = results.first as UserDetails?
            
            callback(userDetails, nil)
            
            return task
        }
    }
}