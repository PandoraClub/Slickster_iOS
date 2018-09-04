//
//  YelpClient.swift
//  Slickster
//
//  Created by NonGT on 9/13/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let yelpConsumerKey = Config.yelp.consumerKey
let yelpConsumerSecret = Config.yelp.consumerSecret
let yelpToken = Config.yelp.token
let yelpTokenSecret = Config.yelp.tokenSecret

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient {
        
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(
                consumerKey: yelpConsumerKey,
                consumerSecret: yelpConsumerSecret,
                accessToken: yelpToken,
                accessSecret: yelpTokenSecret)
        }
        
        return Static.instance!
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(consumerKey key: String!,
        consumerSecret secret: String!,
        accessToken: String!,
        accessSecret: String!) {
        
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = NSURL(string: Config.yelp.endpoint)
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func search(options: YelpSearchOptions,
        completion: ([YelpBusiness]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        
        var parameters = [String: AnyObject]()
        
        if(options.ll != nil) {
            parameters["ll"] = options.ll
        }
        
        if(options.term != nil) {
            parameters["term"] = options.term
        }
        
        if(options.sort != nil) {
            parameters["sort"] = options.sort!
        }
        
        if(options.categories != nil) {
            parameters["category_filter"] = (options.categories!).joinWithSeparator(",")
        }
        
        if(options.deals != nil) {
            parameters["deals_filter"] = options.deals!
        }
            
        if(options.radius != nil) {
            parameters["radius_filter"] = options.radius!
        }
        
        if(options.limit != nil) {
            parameters["limit"] = options.limit!
        }
        
        if(options.offset != nil) {
            parameters["offset"] = options.offset!
        }
            
        if(options.distance != nil) {
            parameters["distance"] = options.distance!
        }
        
        return self.GET("search",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let dictionaries = response["businesses"]! as? [NSDictionary]
                if dictionaries != nil {
                    completion(YelpBusiness.businesses(array: dictionaries!), nil)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })!
    }
}