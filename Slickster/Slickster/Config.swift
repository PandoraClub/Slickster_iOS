//
//  Config.swift
//  Slickster
//
//  Created by NonGT on 9/13/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

struct Config {
    
    struct yelp {
        
        static let consumerKey = "LeBBpU9yQgvWDnNWD14q_w"
        static let consumerSecret = "XyquAe4_X6Ng5zXIko3Yo52eCvQ"
        static let token = "rRiAr4GWhERAAmd30-Gzr-rkJeCGDk13"
        static let tokenSecret = "ToxdVg9AfjKtCzMHn3uVXvIQfvE"
        static let endpoint = "http://api.yelp.com/v2/"
        static let searchLimit = 3
    }
    
    struct parse {
     
        static let appId = "4zW5SYq1szIoMg3POigb2aGOTUXkGtpph6Lz9dc5"
        static let clientKey = "kZKwQ1v21CBv8fa5pclWDIzgX1CZIfATtjnLfQLH"
        static let server = "http://api.slicksterapp.com/parse"
        static let secret3rdPassword = "U6!o7ilJ4o15{hr{Oj2-#90eJ0JJ]2N'ysbxv8>!Qsjz'fy*~yd*]u1,07Q3UO4"
    }
    
    struct google {
        
        static let apiKey = "AIzaSyAOt2RNGikWjkjxyRThviWCIS7s8lYhIho"
        
        // Other google setting is under GoogleService-Info.plist and also linked to settings
    }
    
    struct facebook {
     
        // Facebook setting is under Info.plist
    }
    
    struct eventFul {
        
        static let appKey = "4JHXZhqMdQzjkdgB"
        static let endpoint = "http://api.eventful.com/json/"
    }
    
    struct Eventbrite {
        static let appKey = "URFTRTPVCSIJXQPWNZ2O"
        static let endpoint = "https://www.eventbriteapi.com/v3"
    }
    
    struct slickster {
        
        //static let agendaUrl = "http://agenda.slicksterapp.com"
        static let agendaUrl = "http://slickster.herokuapp.com"
    }
}