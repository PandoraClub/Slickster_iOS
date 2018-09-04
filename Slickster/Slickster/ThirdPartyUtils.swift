//
//  ThirdPartyUtils.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/9/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse

class ThirdPartyUtils {
    
    class func isGoogleUser(user: PFUser) -> Bool {
        
        let authData = user["authDataThirdParty"] as? String
        
        if authData != nil {
            
            let dict = convertStringToDictionary(authData!)
            
            if dict == nil {
                
                return false
            }
            
            return dict!["google"] != nil
        }
        
        return false
    }
    
    class func convertStringToDictionary(text: String) -> [String:String]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            
            let json = try? NSJSONSerialization
                .JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:String]
            
            return json!
        }
        
        return nil
    }
}