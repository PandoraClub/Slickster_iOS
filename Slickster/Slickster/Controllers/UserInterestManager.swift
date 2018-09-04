//
//  UserInterestManager.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/27/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse

class UserInterestManager {
    
    static var sharedInstance = UserInterestManager()
    
    private var userInterests: [UserInterest]?
    
    func isLoaded() -> Bool {
        
        return userInterests != nil
    }
    
    func ensureUserInterests(user: PFUser, callback: ([UserInterest]?, NSError?) -> Void) {
        
        if userInterests != nil {
            
            callback(userInterests, nil)
            
            return
        }
        
        let query = PFQuery(className: UserInterest.parseClassName())
        
        query.whereKey("username", equalTo: user.username!)
        query.findObjectsInBackground().continueWithBlock {
            (task: BFTask!) -> AnyObject in
            
            if(task.error != nil) {
                
                dispatch_async(dispatch_get_main_queue(), {

                    callback(nil, task.error)
                })
                    
                return task
            }
            
            let results = task.result as! [UserInterest]
            
            self.userInterests = results
            
            dispatch_async(dispatch_get_main_queue(), {
            
                callback(results, nil)
            })
            
            return task
        }
    }
    
    func storeUserInterests(user: PFUser, userInterests: [UserInterest], callback: (Bool, NSError?) -> Void) {
            
        var existingLookup = [String:UserInterest]()
        var givenLookup = [String:UserInterest]()
        
        var toBeSaved = [UserInterest]()
        var toBeRemoved = [UserInterest]()
        
        // Create given lookup
        for userInterest in userInterests {
            
            givenLookup[userInterest.selectionKey] = userInterest
        }
        
        // Create existing lookup
        if self.userInterests != nil {
            
            for userInterest in self.userInterests! {
                
                existingLookup[userInterest.selectionKey] = userInterest
            }
        }
        
        // Find entity to be saved
        for userInterest in userInterests {
            
            let existing = existingLookup[userInterest.selectionKey]
            
            if existing != nil {
                
                toBeSaved.append(existing!)
                
            } else {
             
                userInterest.username = PFUser.currentUser()!.username
                toBeSaved.append(userInterest)
            }
        }
        
        // Find entity to be removed
        for userInterest in self.userInterests! {
            
            let found = givenLookup[userInterest.selectionKey]
            
            if found == nil {
                
                toBeRemoved.append(userInterest)
            }
        }
        
        PFObject.deleteAllInBackground(toBeRemoved) { (result, error) -> Void in
            
            if error != nil {
             
                callback(result, error)
                
                return
            }
            
            PFObject.saveAllInBackground(toBeSaved) { (result, error) -> Void in
                
                if error == nil {
                    
                    self.userInterests = userInterests
                }
                
                callback(result, error)
            }
        }
    }
}