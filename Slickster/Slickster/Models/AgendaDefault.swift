//
//  AgendaDefault.swift
//  Slickster
//
//  Created by NonGT on 9/14/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation

class AgendaDefault: NSObject {
    
    static var casual: [AgendaItem]! {
        
        get {
            
            let casual: [AgendaItem]! = [

                AgendaItem(
                    activityType: "Activity",
                    time: AgendaTime.create(11, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Zoos"),
                            YelpCategory.from("Beaches"),
                            YelpCategory.from("Museums")],
                        sort: .Distance,
                        distance: 1
                    )
                ),
                
                AgendaItem(
                    activityType: "Lunch",
                    time: AgendaTime.create(12, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Sandwiches")],
                        
                        sort: .Distance
                    )
                ),
                
                AgendaItem(
                    activityType: "Activity",
                    time: AgendaTime.create(14, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Arcades"),
                            YelpCategory.from("Bowling"),
                            YelpCategory.from("Cinema"),
                            YelpCategory.from("Pool Halls"),
                            YelpCategory.from("Observatories")
                        ],
                        sort: .Distance
                    )
                ),
                
                AgendaItem(
                    activityType: "Dinner",
                    time: AgendaTime.create(18, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Diners")
                        ],
                        sort: .Distance
                    )
                ),
                AgendaItem(activityType:"Eventbrite",
                    eventCategory:"Food & Drink",
                    time: AgendaTime.create(19, minute: 00),
                    condition: AgendaSearchCondition.create(
                        eventBriteCategories: [
                            EventbriteCategory.from("Food & Drink")!
                        ],
                        distance: 1.0
                    )
                )
                
                /*AgendaItem(
                    activityType: "Nightlife",
                    time: AgendaTime.create(20, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("Bars")],
                        sort: .Distance
                    )
                )*/
            ]
            
            return casual
        }
    }
    
    static var family: [AgendaItem]! {
        
        get {
            
            let family: [AgendaItem]! = [
                
                AgendaItem(
                    activityType: "Breakfast",
                    time: AgendaTime.create(8, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Breakfast & Brunch")
                        ],
                        sort: .Distance
                    )
                ),
                
                AgendaItem(
                    activityType: "Activity",
                    time: AgendaTime.create(10, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("Tours")],
                        sort: .Distance
                    )
                ),
                
                AgendaItem(
                    activityType: "Lunch",
                    time: AgendaTime.create(12, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("Bagels")],
                        sort: .Distance
                    )
                ),
                
                AgendaItem(
                    activityType: "Shops",
                    time: AgendaTime.create(14, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("Toy Stores")],
                        sort: .Distance
                    )
                ),
                AgendaItem(activityType:"Eventbrite",
                    eventCategory:"Arts",
                    time: AgendaTime.create(16, minute: 00),
                    condition: AgendaSearchCondition.create(
                        eventBriteCategories: [
                            EventbriteCategory.from("Arts")!
                        ],
                        distance: 1.0
                    )
                )
                /*AgendaItem(
                    activityType: "Activity",
                    time: AgendaTime.create(16, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Playgrounds")
                        ],
                        sort: .Distance,
                        distance: 1
                    )
                )*/,
                
                AgendaItem(
                    activityType: "Dinner",
                    time: AgendaTime.create(18, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("American (Traditional)")
                        ],
                        sort: .Distance
                    )
                )
            ]
            
            return family
        }
    }
    
    static var outdoor: [AgendaItem]! {
        
        get {
            
            let outdoor: [AgendaItem]! = [
                
                AgendaItem(
                    activityType: "Adventure",
                    time: AgendaTime.create(10, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Parks")
                        ],
                        sort: .HighestRated,
                        distance: 5
                    )
                ),
                
                AgendaItem(
                    activityType: "Scenic",
                    time: AgendaTime.create(12, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Hiking")
                        ],
                        sort: .Distance,
                        distance: 3
                    )
                ),
                
                AgendaItem(
                    activityType: "Explore",
                    time: AgendaTime.create(14, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Local Flavor")
                        ],
                        sort: .Distance
                    )
                ),

                AgendaItem(
                    activityType: "Landmarks",
                    time: AgendaTime.create(16, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Landmarks & Historical Buildings")
                        ],
                        sort: .Distance
                    )
                ),

                AgendaItem(
                    activityType: "Food",
                    time: AgendaTime.create(18, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("Food")],
                        sort: .HighestRated,
                        distance: 1
                    )
                ),
                AgendaItem(activityType:"Eventbrite",
                    eventCategory:"Travel & Outdoor",
                    time: AgendaTime.create(20, minute: 00),
                    condition: AgendaSearchCondition.create(
                        eventBriteCategories: [
                            EventbriteCategory.from("Travel & Outdoor")!
                        ],
                        distance: 1.0
                    )
                )
            ]
            
            return outdoor
        }
    }
    
    static var romantic: [AgendaItem]! {
        
        get {
            
            let romantic: [AgendaItem]! = [
                
                AgendaItem(
                    activityType: "Breakfast",
                    time: AgendaTime.create(10, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("Breakfast & Brunch")],
                        sort: .HighestRated
                    )
                ),
                
                AgendaItem(
                    activityType: "Activity",
                    time: AgendaTime.create(11, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("Art Galleries")],
                        term: "museum",
                        sort: .Distance,
                        distance: 1
                    )
                ),

                AgendaItem(
                    activityType: "Lunch",
                    time: AgendaTime.create(12, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("American (New)")],
                        sort: .Distance
                    )
                ),

                AgendaItem(
                    activityType: "Shops",
                    time: AgendaTime.create(14, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Shopping Centers")
                        ],
                        sort: .Distance,
                        distance: 1
                    )
                ),
                
                AgendaItem(
                    activityType: "Dinner",
                    time: AgendaTime.create(17, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [YelpCategory.from("Restaurants")],
                        sort: .HighestRated,
                        distance: 1
                    )
                ),
                AgendaItem(activityType:"Eventbrite",
                    eventCategory:"Music",
                    time: AgendaTime.create(19, minute: 00),
                    condition: AgendaSearchCondition.create(
                        eventBriteCategories: [
                            EventbriteCategory.from("Music")!
                        ],
                        distance: 1.0
                    )
                )

                /*AgendaItem(
                    activityType: "Music",
                    time: AgendaTime.create(20, minute: 0),
                    condition: AgendaSearchCondition.create(
                        
                        categories: [
                            YelpCategory.from("Piano Bars"),
                            YelpCategory.from("Jazz & Blues"),
                            YelpCategory.from("Music Venues")
                        ],
                        sort: .HighestRated
                    )
                )*/
                
            ]
            
            return romantic
        }
    }
    
    static let selectableCategories:[String: [AgendaTypeCategories]] =
    
        [
            "casual": [
    
                AgendaTypeCategories(type: "Breakfast",
                    interestPrefix: "casual-breakfast",
                    minTime: nil,
                    maxTime: AgendaTime.create(11, minute: 30), categories: [
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Breakfast & Brunch"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Internet Cafes"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Activity",
                    interestPrefix: "casual-activity:morning",
                    minTime: nil,
                    maxTime: AgendaTime.create(11, minute: 30), categories: [
                        YelpCategory.from("Aquariums"),
                        YelpCategory.from("Arcades"),
                        YelpCategory.from("Basketball Courts"),
                        YelpCategory.from("Beaches"),
                        YelpCategory.from("Batting Cages"),
                        YelpCategory.from("Bike Rentals"),
                        YelpCategory.from("Boating"),
                        YelpCategory.from("Bowling"),
                        YelpCategory.from("Casinos"),
                        YelpCategory.from("Cabaret"),
                        YelpCategory.from("Cinema"),
                        YelpCategory.from("Climbing"),
                        YelpCategory.from("Comedy Clubs"),
                        YelpCategory.from("Fishing"),
                        YelpCategory.from("Go Karts"),
                        YelpCategory.from("Golf"),
                        YelpCategory.from("Horse Racing"),
                        YelpCategory.from("Jazz & Blues"),
                        YelpCategory.from("Laser Tag"),
                        YelpCategory.from("Mini Golf"),
                        YelpCategory.from("Museums"),
                        YelpCategory.from("Music Venues"),
                        YelpCategory.from("Parks"),
                        YelpCategory.from("Piano Bars"),
                        YelpCategory.from("Pool Halls"),
                        YelpCategory.from("Sledding"),
                        YelpCategory.from("Soccer"),
                        YelpCategory.from("Tennis"),
                        YelpCategory.from("Tubing"),
                        YelpCategory.from("Zoos"),
                        YelpCategory.from("Landmarks & Historical Buildings")
                    ]),

                AgendaTypeCategories(type: "Activity",
                    interestPrefix: "casual-activity:afternoon",
                    minTime: AgendaTime.create(12, minute: 00),
                    maxTime: AgendaTime.create(22, minute: 00), categories: [
                        YelpCategory.from("Aquariums"),
                        YelpCategory.from("Arcades"),
                        YelpCategory.from("Basketball Courts"),
                        YelpCategory.from("Beaches"),
                        YelpCategory.from("Batting Cages"),
                        YelpCategory.from("Bike Rentals"),
                        YelpCategory.from("Boating"),
                        YelpCategory.from("Bowling"),
                        YelpCategory.from("Casinos"),
                        YelpCategory.from("Cabaret"),
                        YelpCategory.from("Cinema"),
                        YelpCategory.from("Climbing"),
                        YelpCategory.from("Comedy Clubs"),
                        YelpCategory.from("Fishing"),
                        YelpCategory.from("Go Karts"),
                        YelpCategory.from("Golf"),
                        YelpCategory.from("Horse Racing"),
                        YelpCategory.from("Jazz & Blues"),
                        YelpCategory.from("Laser Tag"),
                        YelpCategory.from("Mini Golf"),
                        YelpCategory.from("Museums"),
                        YelpCategory.from("Music Venues"),
                        YelpCategory.from("Parks"),
                        YelpCategory.from("Piano Bars"),
                        YelpCategory.from("Pool Halls"),
                        YelpCategory.from("Sledding"),
                        YelpCategory.from("Soccer"),
                        YelpCategory.from("Tennis"),
                        YelpCategory.from("Tubing"),
                        YelpCategory.from("Zoos"),
                        YelpCategory.from("Landmarks & Historical Buildings")
                ]),

                AgendaTypeCategories(type: "Lunch",
                    interestPrefix: "casual-lunch",
                    minTime: AgendaTime.create(11, minute: 30),
                    maxTime: AgendaTime.create(14, minute: 00), categories: [
                        YelpCategory.from("American (New)"),
                        YelpCategory.from("American (Traditional)"),
                        YelpCategory.from("Asian Fusion"),
                        YelpCategory.from("Diners"),
                        YelpCategory.from("Hot Dogs"),
                        YelpCategory.from("Pizza"),
                        YelpCategory.from("Sushi Bars"),
                        YelpCategory.from("Sandwiches"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Breakfast & Brunch"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),

                AgendaTypeCategories(type: "Food",
                    interestPrefix: "casual-food",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("American (New)"),
                        YelpCategory.from("American (Traditional)"),
                        YelpCategory.from("Asian Fusion"),
                        YelpCategory.from("Diners"),
                        YelpCategory.from("Hot Dogs"),
                        YelpCategory.from("Pizza"),
                        YelpCategory.from("Sushi Bars"),
                        YelpCategory.from("Sandwiches"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Breakfast & Brunch"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),

                AgendaTypeCategories(type: "Shops",
                    interestPrefix: "casual-shops",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("Bookstores"),
                        YelpCategory.from("Books, Mags, Music & Video"),
                        YelpCategory.from("Comic Books"),
                        YelpCategory.from("Flea Markets"),
                        YelpCategory.from("Hobby Shops"),
                        YelpCategory.from("Jewelry"),
                        YelpCategory.from("Shopping Centers"),
                        YelpCategory.from("Souvenir Shops"),
                        YelpCategory.from("Tobacco Shops"),
                        YelpCategory.from("Used Bookstore"),
                        YelpCategory.from("Vape Shops"),
                        YelpCategory.from("Video Game Stores"),
                        YelpCategory.from("Pet Stores"),
                        YelpCategory.from("Men's Clothing"),
                        YelpCategory.from("Women's Clothing"),
                        YelpCategory.from("Department Stores")
                    ]),
                
                AgendaTypeCategories(type: "Dinner",
                    interestPrefix: "casual-dinner",
                    minTime: AgendaTime.create(17, minute: 00),
                    maxTime: nil, categories: [
                        YelpCategory.from("American (New)"),
                        YelpCategory.from("American (Traditional)"),
                        YelpCategory.from("Asian Fusion"),
                        YelpCategory.from("Diners"),
                        YelpCategory.from("Hot Dogs"),
                        YelpCategory.from("Pizza"),
                        YelpCategory.from("Sushi Bars"),
                        YelpCategory.from("Sandwiches"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Nightlife",
                    interestPrefix: "casual-nightlife",
                    minTime: AgendaTime.create(19, minute: 00),
                    maxTime: nil, categories: [
                        YelpCategory.from("Bars"),
                        YelpCategory.from("Cocktail Bars"),
                        YelpCategory.from("Dive Bars"),
                        YelpCategory.from("Hookah Bars"),
                        YelpCategory.from("Lounges"),
                        YelpCategory.from("Comedy Clubs"),
                        YelpCategory.from("Jazz & Blues"),
                        YelpCategory.from("Music Venues"),
                        YelpCategory.from("Karaoke"),
                        YelpCategory.from("Piano Bars"),
                        YelpCategory.from("Pool Halls")
                    ]),
                    
                AgendaTypeCategories(type: "Snack",
                    interestPrefix: "casual-snack",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Candy Stores"),
                        YelpCategory.from("Grocery"),
                        YelpCategory.from("Pretzels"),
                        YelpCategory.from("Ice Cream & Frozen Yogurt"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Custom",
                    interestPrefix: nil,
                    minTime: nil,
                    maxTime: nil, categories: YelpCategories.sharedInstance.getCategories()),
                
//                AgendaTypeCategories(type: "Event",
//                    minTime: nil,
//                    maxTime: nil, categories: nil,
//                    eventCategories: EventFulCategories.sharedInstance.getCategories())
            ],
            
            "family": [
                
                AgendaTypeCategories(type: "Breakfast",
                    interestPrefix: "family-breakfast",
                    minTime: nil,
                    maxTime: AgendaTime.create(10, minute: 00), categories: [
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Cafes"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Breakfast & Brunch"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Activity",
                    interestPrefix: "family-activity:morning",
                    minTime: nil,
                    maxTime: AgendaTime.create(10, minute: 00), categories: [
                        YelpCategory.from("Amusement Parks"),
                        YelpCategory.from("Aquariums"),
                        YelpCategory.from("Arcades"),
                        YelpCategory.from("Basketball Courts"),
                        YelpCategory.from("Beaches"),
                        YelpCategory.from("Batting Cages"),
                        YelpCategory.from("Bike Rentals"),
                        YelpCategory.from("Boating"),
                        YelpCategory.from("Bowling"),
                        YelpCategory.from("Landmarks & Historical Buildings"),
                        YelpCategory.from("Cinema"),
                        YelpCategory.from("Fishing"),
                        YelpCategory.from("Go Karts"),
                        YelpCategory.from("Laser Tag"),
                        YelpCategory.from("Mini Golf"),
                        YelpCategory.from("Museums"),
                        YelpCategory.from("Music Venues"),
                        YelpCategory.from("Parks"),
                        YelpCategory.from("Soccer"),
                        YelpCategory.from("Tennis"),
                        YelpCategory.from("Observatories"),
                        YelpCategory.from("Zoos"),
                        YelpCategory.from("Sledding"),
                        YelpCategory.from("Tubing")
                    ]),

                AgendaTypeCategories(type: "Activity",
                    interestPrefix: "family-activity:afternoon",
                    minTime: AgendaTime.create(13, minute: 00),
                    maxTime: AgendaTime.create(18, minute: 00), categories: [
                        YelpCategory.from("Playgrounds"),
                        YelpCategory.from("Performing Arts"),
                        YelpCategory.from("Aquariums"),
                        YelpCategory.from("Arcades"),
                        YelpCategory.from("Basketball Courts"),
                        YelpCategory.from("Beaches"),
                        YelpCategory.from("Batting Cages"),
                        YelpCategory.from("Bike Rentals"),
                        YelpCategory.from("Boating"),
                        YelpCategory.from("Bowling"),
                        YelpCategory.from("Kids Activities"),
                        YelpCategory.from("Cinema"),
                        YelpCategory.from("Go Karts"),
                        YelpCategory.from("Laser Tag"),
                        YelpCategory.from("Mini Golf"),
                        YelpCategory.from("Museums"),
                        YelpCategory.from("Parks"),
                        YelpCategory.from("Planetarium"),
                        YelpCategory.from("Sledding"),
                        YelpCategory.from("Soccer"),
                        YelpCategory.from("Tennis"),
                        YelpCategory.from("Tubing"),
                        YelpCategory.from("Zoos")
                    ]),
                
                AgendaTypeCategories(type: "Lunch",
                    interestPrefix: "family-lunch",
                    minTime: AgendaTime.create(11, minute: 30),
                    maxTime: AgendaTime.create(12, minute: 30), categories: [
                        YelpCategory.from("American (New)"),
                        YelpCategory.from("American (Traditional)"),
                        YelpCategory.from("Asian Fusion"),
                        YelpCategory.from("Diners"),
                        YelpCategory.from("Hot Dogs"),
                        YelpCategory.from("Pizza"),
                        YelpCategory.from("Sushi Bars"),
                        YelpCategory.from("Sandwiches"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Snack",
                    interestPrefix: "family-snack",
                    minTime: AgendaTime.create(11, minute: 30),
                    maxTime: AgendaTime.create(12, minute: 30), categories: [
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Candy Stores"),
                        YelpCategory.from("Grocery"),
                        YelpCategory.from("Pretzels"),
                        YelpCategory.from("Ice Cream & Frozen Yogurt"),
                        YelpCategory.from("Fruits & Veggies")
                    ]),
                
                AgendaTypeCategories(type: "Shops",
                    interestPrefix: "family-shops",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("Bookstores"),
                        YelpCategory.from("Books, Mags, Music & Video"),
                        YelpCategory.from("Comic Books"),
                        YelpCategory.from("Flea Markets"),
                        YelpCategory.from("Hobby Shops"),
                        YelpCategory.from("Jewelry"),
                        YelpCategory.from("Shopping Centers"),
                        YelpCategory.from("Souvenir Shops"),
                        YelpCategory.from("Toy Stores"),
                        YelpCategory.from("Video Game Stores")
                    ]),
                
                AgendaTypeCategories(type: "Dinner",
                    interestPrefix: "family-dinner",
                    minTime: AgendaTime.create(17, minute: 00),
                    maxTime: nil, categories: [
                        YelpCategory.from("American (New)"),
                        YelpCategory.from("American (Traditional)"),
                        YelpCategory.from("Asian Fusion"),
                        YelpCategory.from("Diners"),
                        YelpCategory.from("Hot Dogs"),
                        YelpCategory.from("Pizza"),
                        YelpCategory.from("Sushi Bars"),
                        YelpCategory.from("Sandwiches"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Custom",
                    interestPrefix: nil,
                    minTime: nil,
                    maxTime: nil, categories: YelpCategories.sharedInstance.getCategories()),
                
//                AgendaTypeCategories(type: "Event",
//                    minTime: nil,
//                    maxTime: nil, categories: nil)
            ],
            
            "outdoor": [

                AgendaTypeCategories(type: "Adventure",
                    interestPrefix: "outdoor-adventure",
                    minTime: nil,
                    maxTime: AgendaTime.create(17, minute: 00), categories: [
                        YelpCategory.from("Parks"),
                        YelpCategory.from("Campgrounds"),
                        YelpCategory.from("Lakes"),
                        YelpCategory.from("Boating"),
                        YelpCategory.from("Fishing"),
                        YelpCategory.from("Climbing"),
                        YelpCategory.from("Sledding"),
                        YelpCategory.from("Skiing"),
                        YelpCategory.from("Zoos")
                    ]),

                AgendaTypeCategories(type: "Water",
                    interestPrefix: "outdoor-water",
                    minTime: nil,
                    maxTime: AgendaTime.create(17, minute: 00), categories: [
                        YelpCategory.from("Beaches"),
                        YelpCategory.from("Boating"),
                        YelpCategory.from("Fishing"),
                        YelpCategory.from("Lakes")
                    ]),
                
                AgendaTypeCategories(type: "Activity",
                    interestPrefix: "outdoor-activity",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("Basketball Courts"),
                        YelpCategory.from("Batting Cages"),
                        YelpCategory.from("Bike Rentals"),
                        YelpCategory.from("Climbing"),
                        YelpCategory.from("Go Karts"),
                        YelpCategory.from("Golf"),
                        YelpCategory.from("Horse Racing"),
                        YelpCategory.from("Mini Golf"),
                        YelpCategory.from("Sledding"),
                        YelpCategory.from("Soccer"),
                        YelpCategory.from("Tennis"),
                        YelpCategory.from("Tubing"),
                        YelpCategory.from("Zoos")
                    ]),

                AgendaTypeCategories(type: "Explore",
                    interestPrefix: "outdoor-explore",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("Active Life"),
                        YelpCategory.from("Castles"),
                        YelpCategory.from("Parks"),
                        YelpCategory.from("Lakes"),
                        YelpCategory.from("Botanical Gardens"),
                        YelpCategory.from("Landmarks & Historical Buildings"),
                        YelpCategory.from("Local Flavor")
                    ]),
                
                AgendaTypeCategories(type: "Food",
                    interestPrefix: "outdoor-food",
                    minTime: nil,
                    maxTime: AgendaTime.create(20, minute: 00), categories: [
                        YelpCategory.from("Food"),
                        YelpCategory.from("Food Stands"),
                        YelpCategory.from("Flea Markets"),
                        YelpCategory.from("American (New)"),
                        YelpCategory.from("American (Traditional)"),
                        YelpCategory.from("Asian Fusion"),
                        YelpCategory.from("Diners"),
                        YelpCategory.from("Hot Dogs"),
                        YelpCategory.from("Pizza"),
                        YelpCategory.from("Sushi Bars"),
                        YelpCategory.from("Sandwiches"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),

                AgendaTypeCategories(type: "Landmarks",
                    interestPrefix: "outdoor-landmarks",
                    minTime: nil,
                    maxTime: AgendaTime.create(18, minute: 00), categories: [
                        YelpCategory.from("Landmarks & Historical Buildings"),
                        YelpCategory.from("Arts & Entertainment")
                    ]),

                AgendaTypeCategories(type: "Scenic",
                    interestPrefix: "outdoor-scenic",
                    minTime: nil,
                    maxTime: AgendaTime.create(18, minute: 00), categories: [
                        YelpCategory.from("Hiking"),
                        YelpCategory.from("Local Flavor"),
                        YelpCategory.from("Beaches"),
                        YelpCategory.from("Botanical Gardens"),
                        YelpCategory.from("Lakes")
                    ]),

                AgendaTypeCategories(type: "Custom",
                    interestPrefix: nil,
                    minTime: nil,
                    maxTime: nil, categories: YelpCategories.sharedInstance.getCategories()),
                
//                AgendaTypeCategories(type: "Event",
//                    minTime: nil,
//                    maxTime: nil, categories: nil)
            ],
            
            "romantic": [
                
                AgendaTypeCategories(type: "Breakfast",
                    interestPrefix: "romantic-breakfast",
                    minTime: nil,
                    maxTime: AgendaTime.create(10, minute: 00), categories: [
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Breakfast & Brunch"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Activity",
                    interestPrefix: "romantic-activity:morning",
                    minTime: nil,
                    maxTime: AgendaTime.create(12, minute: 00), categories: [
                        YelpCategory.from("Botanical Gardens"),
                        YelpCategory.from("Boating"),
                        YelpCategory.from("Cinema"),
                        YelpCategory.from("Horseback Riding"),
                        YelpCategory.from("Museums"),
                        YelpCategory.from("Aquariums"),
                        YelpCategory.from("Arcades"),
                        YelpCategory.from("Beaches"),
                        YelpCategory.from("Batting Cages"),
                        YelpCategory.from("Bike Rentals"),
                        YelpCategory.from("Bowling"),
                        YelpCategory.from("Casinos"),
                        YelpCategory.from("Cabaret"),
                        YelpCategory.from("Cinema"),
                        YelpCategory.from("Climbing"),
                        YelpCategory.from("Comedy Clubs"),
                        YelpCategory.from("Fishing"),
                        YelpCategory.from("Go Karts"),
                        YelpCategory.from("Golf"),
                        YelpCategory.from("Horse Racing"),
                        YelpCategory.from("Jazz & Blues"),
                        YelpCategory.from("Laser Tag"),
                        YelpCategory.from("Mini Golf"),
                        YelpCategory.from("Music Venues"),
                        YelpCategory.from("Parks"),
                        YelpCategory.from("Piano Bars"),
                        YelpCategory.from("Pool Halls"),
                        YelpCategory.from("Sledding"),
                        YelpCategory.from("Soccer"),
                        YelpCategory.from("Tennis"),
                        YelpCategory.from("Tubing"),
                        YelpCategory.from("Zoos"),
                        YelpCategory.from("Landmarks & Historical Buildings")
                    ]),

                AgendaTypeCategories(type: "Activity",
                    interestPrefix: "romantic-activity:afternoon",
                    minTime: AgendaTime.create(13, minute: 00),
                    maxTime: AgendaTime.create(17, minute: 00), categories: [
                        YelpCategory.from("Beaches"),
                        YelpCategory.from("Boating"),
                        YelpCategory.from("Cabaret"),
                        YelpCategory.from("Cinema"),
                        YelpCategory.from("Comedy Clubs"),
                        YelpCategory.from("Jazz & Blues"),
                        YelpCategory.from("Museums"),
                        YelpCategory.from("Music Venues"),
                        YelpCategory.from("Aquariums"),
                        YelpCategory.from("Arcades"),
                        YelpCategory.from("Batting Cages"),
                        YelpCategory.from("Bike Rentals"),
                        YelpCategory.from("Bowling"),
                        YelpCategory.from("Casinos"),
                        YelpCategory.from("Climbing"),
                        YelpCategory.from("Comedy Clubs"),
                        YelpCategory.from("Fishing"),
                        YelpCategory.from("Go Karts"),
                        YelpCategory.from("Golf"),
                        YelpCategory.from("Horse Racing"),
                        YelpCategory.from("Jazz & Blues"),
                        YelpCategory.from("Laser Tag"),
                        YelpCategory.from("Mini Golf"),
                        YelpCategory.from("Music Venues"),
                        YelpCategory.from("Parks"),
                        YelpCategory.from("Piano Bars"),
                        YelpCategory.from("Pool Halls"),
                        YelpCategory.from("Sledding"),
                        YelpCategory.from("Soccer"),
                        YelpCategory.from("Tennis"),
                        YelpCategory.from("Tubing"),
                        YelpCategory.from("Zoos"),
                        YelpCategory.from("Landmarks & Historical Buildings")
                    ]),

                AgendaTypeCategories(type: "Lunch",
                    interestPrefix: "romantic-lunch",
                    minTime: AgendaTime.create(11, minute: 30),
                    maxTime: AgendaTime.create(14, minute: 00), categories: [
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Breakfast & Brunch"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Shops",
                    interestPrefix: "romantic-shops",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("Jewelry"),
                        YelpCategory.from("Shopping"),
                        YelpCategory.from("Shopping Centers"),
                        YelpCategory.from("Men's Clothing"),
                        YelpCategory.from("Women's Clothing")
                    ]),

                AgendaTypeCategories(type: "Music",
                    interestPrefix: "romantic-music",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("Piano Bars"),
                        YelpCategory.from("Jazz & Blues"),
                        YelpCategory.from("Music Venues")
                    ]),

                AgendaTypeCategories(type: "Dinner",
                    interestPrefix: "romantic-dinner",
                    minTime: AgendaTime.create(17, minute: 00),
                    maxTime: nil, categories: [
                        YelpCategory.from("American (New)"),
                        YelpCategory.from("American (Traditional)"),
                        YelpCategory.from("Asian Fusion"),
                        YelpCategory.from("Diners"),
                        YelpCategory.from("Hot Dogs"),
                        YelpCategory.from("Pizza"),
                        YelpCategory.from("Sushi Bars"),
                        YelpCategory.from("Sandwiches"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Farmers Market"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Bakeries"),
                        YelpCategory.from("Creperies"),
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),

                AgendaTypeCategories(type: "Nightlife",
                    interestPrefix: "romantic-nightlife",
                    minTime: AgendaTime.create(19, minute: 00),
                    maxTime: nil, categories: [
                        YelpCategory.from("Cocktail Bars"),
                        YelpCategory.from("Lounges"),
                        YelpCategory.from("Karaoke"),
                        YelpCategory.from("Piano Bars"),
                        YelpCategory.from("Nightlife")
                    ]),
                
                AgendaTypeCategories(type: "Snack",
                    interestPrefix: "romantic-snack",
                    minTime: nil,
                    maxTime: nil, categories: [
                        YelpCategory.from("Coffee & Tea"),
                        YelpCategory.from("Juice Bars & Smoothies"),
                        YelpCategory.from("Donuts"),
                        YelpCategory.from("Candy Stores"),
                        YelpCategory.from("Grocery"),
                        YelpCategory.from("Pretzels"),
                        YelpCategory.from("Ice Cream & Frozen Yogurt"),
                        YelpCategory.from("Bagels"),
                        YelpCategory.from("Fruits & Veggies"),
                        YelpCategory.from("Halal"),
                        YelpCategory.from("Kosher"),
                        YelpCategory.from("Vegan"),
                        YelpCategory.from("Vegetarian")
                    ]),
                
                AgendaTypeCategories(type: "Custom",
                    interestPrefix: nil,
                    minTime: nil,
                    maxTime: nil, categories: YelpCategories.sharedInstance.getCategories()),
                
//                AgendaTypeCategories(type: "Event",
//                    minTime: nil,
//                    maxTime: nil, categories: nil)
            ]
        ]
}