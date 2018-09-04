//
//  AgendaManager.swift
//  Slickster
//
//  Created by NonGT on 10/18/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse

class AgendaManager {

    static var sharedInstance = AgendaManager()
    
    private var presentAgendas: [UserAgenda]?
    
    func getUserAgendas(user: PFUser, callback: ([UserAgenda]?, NSError?) -> Void) {
     
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {

            let query = PFQuery(className: UserAgenda.parseClassName())
            
            query.whereKey("username", equalTo: user.username!)
            query.findObjectsInBackground().continueWithBlock {
                (task: BFTask!) -> AnyObject in
                
                if(task.error != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), {

                        callback(nil, task.error)
                    })
                    
                    return task
                }
                
                let results = task.result as! [UserAgenda]
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callback(results, nil)
                })
                
                return task
            }
        }
    }
    
    func getSharedAgenda(id: String, callback: (UserAgenda?, NSError?) -> Void) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            let query = PFQuery(className: UserAgenda.parseClassName())
            
            query.whereKey("uuid", equalTo: id)
            query.findObjectsInBackground().continueWithBlock {
                (task: BFTask!) -> AnyObject in
                
                if(task.error != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        callback(nil, task.error)
                    })
                    
                    return task
                }
                
                let results = task.result as! [UserAgenda]
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if results.count > 0 {
                        callback(results[0], nil)
                    } else {
                        
                        callback(UserAgenda(), nil)
                    }
                })
                
                return task
            }
        }
    }
    
    func getPresentUserAgendas(user: PFUser, callback: ([UserAgenda]?, NSError?) -> Void) {
        
        if presentAgendas != nil {
        
            callback(presentAgendas, nil)
            return
        }
    
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            let query = PFQuery(className: UserAgenda.parseClassName())
            
            query.whereKey("username", equalTo: user.username!)
            query.whereKey("date", greaterThanOrEqualTo: NSDate())
            query.findObjectsInBackground().continueWithBlock {
                (task: BFTask!) -> AnyObject in
                
                if(task.error != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        callback(nil, task.error)
                    })
                    
                    return task
                }
                
                let results = task.result as! [UserAgenda]
                self.presentAgendas = results
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callback(results, nil)
                })
                
                return task
            }
        }
    }
    
    func isPresentAgendasCacheExists() -> Bool {
    
        return presentAgendas != nil
    }
    
    func clearPresentAgendasCache() {
    
        presentAgendas = nil
    }
}