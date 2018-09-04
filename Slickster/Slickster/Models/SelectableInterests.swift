//
//  SelectableInterests.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/24/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation

class SelectableInterests {
    
    static let sharedInstance = SelectableInterests()
    
    var groups = [String:InterestCategories]()
    
    init() {
        
        initFavFood()
        initFavSnack()
        initFavShopping()
        initFavCasualDayActivities()
        initFavCasualNightActivities()
        initFavRomanticDayActivities()
        initFavRomanticNightActivities()
        initFavFamilyDayActivities()
        initFavFamilyNightActivities()
        initFavOutdoorActivities()
    }
    
    func initFavFood() {
        
        let fav = InterestCategories()
        
        fav.key = "food"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Breakfast" {
                
                return true
            }
            
            if type == "Lunch" {
                
                return true
            }
            
            if type == "Dinner" {
                
                return true
            }
            
            return false
        }
        
        fav.iconSuffix = "casual"
        
        fav.categories = [
            
            YelpCategories.sharedInstance.find("American (New)"),
            YelpCategories.sharedInstance.find("American (Traditional)"),
            YelpCategories.sharedInstance.find("Asian Fusion"),
            YelpCategories.sharedInstance.find("Bagels"),
            YelpCategories.sharedInstance.find("Bakeries"),
            YelpCategories.sharedInstance.find("Breakfast & Brunch"),
            YelpCategories.sharedInstance.find("Coffee & Tea"),
            YelpCategories.sharedInstance.find("Creperies"),
            YelpCategories.sharedInstance.find("Diners"),
            YelpCategories.sharedInstance.find("Donuts"),
            YelpCategories.sharedInstance.find("Farmers Market"),
            YelpCategories.sharedInstance.find("Fruits & Veggies"),
            YelpCategories.sharedInstance.find("Halal"),
            YelpCategories.sharedInstance.find("Hot Dogs"),
            YelpCategories.sharedInstance.find("Jewish"),
            YelpCategories.sharedInstance.find("Juice Bars & Smoothies"),
            YelpCategories.sharedInstance.find("Kosher"),
            YelpCategories.sharedInstance.find("Pizza"),
            YelpCategories.sharedInstance.find("Sandwiches"),
            YelpCategories.sharedInstance.find("Sushi Bars"),
            YelpCategories.sharedInstance.find("Vegan"),
            YelpCategories.sharedInstance.find("Vegetarian")
        ]
        
        groups["Food"] = fav
    }
    
    func initFavSnack() {
        
        let fav = InterestCategories()
        
        fav.key = "snack"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Snack" {
                
                return true
            }
            
            return false
        }
        
        fav.iconSuffix = "casual"
        
        fav.categories = [
            
            YelpCategories.sharedInstance.find("Bagels"),
            YelpCategories.sharedInstance.find("Bakeries"),
            YelpCategories.sharedInstance.find("Breakfast & Brunch"),
            YelpCategories.sharedInstance.find("Candy Stores"),
            YelpCategories.sharedInstance.find("Coffee & Tea"),
            YelpCategories.sharedInstance.find("Donuts"),
            YelpCategories.sharedInstance.find("Fruits & Veggies"),
            YelpCategories.sharedInstance.find("Grocery"),
            YelpCategories.sharedInstance.find("Halal"),
            YelpCategories.sharedInstance.find("Ice Cream & Frozen Yogurt"),
            YelpCategories.sharedInstance.find("Jewish"),
            YelpCategories.sharedInstance.find("Juice Bars & Smoothies"),
            YelpCategories.sharedInstance.find("Kosher"),
            YelpCategories.sharedInstance.find("Pretzels"),
            YelpCategories.sharedInstance.find("Vegan"),
            YelpCategories.sharedInstance.find("Vegetarian")
        ]
        
        groups["Snack"] = fav
    }
    
    func initFavShopping() {
        
        let fav = InterestCategories()
        
        fav.key = "shop"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Shop" {
                
                return true
            }
            
            return false
        }
        
        fav.iconSuffix = "casual"
        
        fav.categories = [

            YelpCategories.sharedInstance.find("Books, Mags, Music & Video"),
            YelpCategories.sharedInstance.find("Bookstores"),
            YelpCategories.sharedInstance.find("Comic Books"),
            YelpCategories.sharedInstance.find("Department Stores"),
            YelpCategories.sharedInstance.find("Flea Markets"),
            YelpCategories.sharedInstance.find("Hobby Shops"),
            YelpCategories.sharedInstance.find("Jewelry"),
            YelpCategories.sharedInstance.find("Men's Clothing"),
            YelpCategories.sharedInstance.find("Pet Stores"),
            YelpCategories.sharedInstance.find("Shopping Centers"),
            YelpCategories.sharedInstance.find("Souvenir Shops"),
            YelpCategories.sharedInstance.find("Tobacco Shops"),
            YelpCategories.sharedInstance.find("Toy Stores"),
            YelpCategories.sharedInstance.find("Used Bookstore"),
            YelpCategories.sharedInstance.find("Vape Shops"),
            YelpCategories.sharedInstance.find("Video Game Stores"),
            YelpCategories.sharedInstance.find("Women's Clothing")
        ]
        
        groups["Shopping"] = fav
    }
    
    func initFavCasualDayActivities() {
        
        let fav = InterestCategories()
        
        fav.key = "activity-casual-day"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Activities" {
                
                return true
            }
            
            return false
        }
        
        fav.isDayTime = true
        fav.templateType = "casual"
        fav.iconSuffix = "casual"
        
        fav.categories = [

            YelpCategories.sharedInstance.find("Aquariums"),
            YelpCategories.sharedInstance.find("Arcades"),
            YelpCategories.sharedInstance.find("Basketball Courts"),
            YelpCategories.sharedInstance.find("Batting Cages"),
            YelpCategories.sharedInstance.find("Beaches"),
            YelpCategories.sharedInstance.find("Bike Rentals"),
            YelpCategories.sharedInstance.find("Boating"),
            YelpCategories.sharedInstance.find("Bowling"),
            YelpCategories.sharedInstance.find("Cabaret"),
            YelpCategories.sharedInstance.find("Casinos"),
            YelpCategories.sharedInstance.find("Cinema"),
            YelpCategories.sharedInstance.find("Climbing"),
            YelpCategories.sharedInstance.find("Comedy Clubs"),
            YelpCategories.sharedInstance.find("Fishing"),
            YelpCategories.sharedInstance.find("Go Karts"),
            YelpCategories.sharedInstance.find("Golf"),
            YelpCategories.sharedInstance.find("Horse Racing"),
            YelpCategories.sharedInstance.find("Jazz & Blues"),
            YelpCategories.sharedInstance.find("Laser Tag"),
            YelpCategories.sharedInstance.find("Mini Golf"),
            YelpCategories.sharedInstance.find("Museums"),
            YelpCategories.sharedInstance.find("Music Venues"),
            YelpCategories.sharedInstance.find("Parks"),
            YelpCategories.sharedInstance.find("Piano Bars"),
            YelpCategories.sharedInstance.find("Pool Halls"),
            YelpCategories.sharedInstance.find("Sledding"),
            YelpCategories.sharedInstance.find("Soccer"),
            YelpCategories.sharedInstance.find("Tennis"),
            YelpCategories.sharedInstance.find("Tubing"),
            YelpCategories.sharedInstance.find("Zoos")
        ]
        
        groups["Casual Day Time"] = fav
    }
    
    func initFavCasualNightActivities() {
        
        let fav = InterestCategories()
        
        fav.key = "activity-casual-night"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Activities" {
                
                return true
            }
            
            return false
        }
        
        fav.isDayTime = false
        fav.templateType = "casual"
        fav.iconSuffix = "casual"
        
        fav.categories = [
            
            YelpCategories.sharedInstance.find("Arcades"),
            YelpCategories.sharedInstance.find("Bars"),
            YelpCategories.sharedInstance.find("Batting Cages"),
            YelpCategories.sharedInstance.find("Bowling"),
            YelpCategories.sharedInstance.find("Cabaret"),
            YelpCategories.sharedInstance.find("Casinos"),
            YelpCategories.sharedInstance.find("Cinema"),
            YelpCategories.sharedInstance.find("Climbing"),
            YelpCategories.sharedInstance.find("Cocktail Bars"),
            YelpCategories.sharedInstance.find("Comedy Clubs"),
            YelpCategories.sharedInstance.find("Dive Bars"),
            YelpCategories.sharedInstance.find("Go Karts"),
            YelpCategories.sharedInstance.find("Golf"),
            YelpCategories.sharedInstance.find("Hookah Bars"),
            YelpCategories.sharedInstance.find("Horse Racing"),
            YelpCategories.sharedInstance.find("Jazz & Blues"),
            YelpCategories.sharedInstance.find("Karaoke"),
            YelpCategories.sharedInstance.find("Laser Tag"),
            YelpCategories.sharedInstance.find("Lounges"),
            YelpCategories.sharedInstance.find("Mini Golf"),
            YelpCategories.sharedInstance.find("Museums"),
            YelpCategories.sharedInstance.find("Music Venues"),
            YelpCategories.sharedInstance.find("Parks"),
            YelpCategories.sharedInstance.find("Piano Bars"),
            YelpCategories.sharedInstance.find("Pool Halls"),
            YelpCategories.sharedInstance.find("Sledding"),
            YelpCategories.sharedInstance.find("Soccer"),
            YelpCategories.sharedInstance.find("Tennis"),
            YelpCategories.sharedInstance.find("Tubing")
        ]
        
        groups["Casual Night Time"] = fav
    }
    
    func initFavRomanticDayActivities() {
        
        let fav = InterestCategories()
        
        fav.key = "activity-romantic-day"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Activities" {
                
                return true
            }
            
            return false
        }
        
        fav.isDayTime = true
        fav.templateType = "romantic"
        fav.iconSuffix = "romantic"
        
        fav.categories = [
            
            YelpCategories.sharedInstance.find("Beaches"),
            YelpCategories.sharedInstance.find("Boating"),
            YelpCategories.sharedInstance.find("Botanical Gardens"),
            YelpCategories.sharedInstance.find("Cabaret"),
            YelpCategories.sharedInstance.find("Cinema"),
            YelpCategories.sharedInstance.find("Comedy Clubs"),
            YelpCategories.sharedInstance.find("Horseback Riding"),
            YelpCategories.sharedInstance.find("Jazz & Blues"),
            YelpCategories.sharedInstance.find("Museums"),
            YelpCategories.sharedInstance.find("Music Venues")
        ]
        
        groups["Romantic Day Time"] = fav
    }
    
    func initFavRomanticNightActivities() {
        
        let fav = InterestCategories()
        
        fav.key = "activity-romantic-night"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Activities" {
                
                return true
            }
            
            return false
        }
        
        fav.isDayTime = false
        fav.templateType = "romantic"
        fav.iconSuffix = "romantic"
        
        fav.categories = [

            YelpCategories.sharedInstance.find("Bars"),
            YelpCategories.sharedInstance.find("Cocktail Bars"),
            YelpCategories.sharedInstance.find("Cinema"),
            YelpCategories.sharedInstance.find("Comedy Clubs"),
            YelpCategories.sharedInstance.find("Dive Bars"),
            YelpCategories.sharedInstance.find("Hookah Bars"),
            YelpCategories.sharedInstance.find("Jazz & Blues"),
            YelpCategories.sharedInstance.find("Karaoke"),
            YelpCategories.sharedInstance.find("Lounges"),
            YelpCategories.sharedInstance.find("Music Venues"),
            YelpCategories.sharedInstance.find("Piano Bars"),
            YelpCategories.sharedInstance.find("Pool Halls")
        ]
        
        groups["Romantic Night Time"] = fav
    }
    
    func initFavFamilyDayActivities() {
        
        let fav = InterestCategories()
        
        fav.key = "activity-family-day"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Activities" {
                
                return true
            }
            
            return false
        }
        
        fav.isDayTime = true
        fav.templateType = "family"
        fav.iconSuffix = "family"
        
        fav.categories = [

            YelpCategories.sharedInstance.find("Amusement Parks"),
            YelpCategories.sharedInstance.find("Aquariums"),
            YelpCategories.sharedInstance.find("Arcades"),
            YelpCategories.sharedInstance.find("Basketball Courts"),
            YelpCategories.sharedInstance.find("Batting Cages"),
            YelpCategories.sharedInstance.find("Beaches"),
            YelpCategories.sharedInstance.find("Bike Rentals"),
            YelpCategories.sharedInstance.find("Boating"),
            YelpCategories.sharedInstance.find("Bowling"),
            YelpCategories.sharedInstance.find("Cinema"),
            YelpCategories.sharedInstance.find("Fishing"),
            YelpCategories.sharedInstance.find("Go Karts"),
            YelpCategories.sharedInstance.find("Landmarks & Historical Buildings"),
            YelpCategories.sharedInstance.find("Laser Tag"),
            YelpCategories.sharedInstance.find("Mini Golf"),
            YelpCategories.sharedInstance.find("Museums"),
            YelpCategories.sharedInstance.find("Music Venues"),
            YelpCategories.sharedInstance.find("Observatories"),
            YelpCategories.sharedInstance.find("Parks"),
            YelpCategories.sharedInstance.find("Soccer"),
            YelpCategories.sharedInstance.find("Tennis"),
            YelpCategories.sharedInstance.find("Zoos"),
            YelpCategories.sharedInstance.find("Sledding"),
            YelpCategories.sharedInstance.find("Tubing")
        ]
        
        groups["Family Day Time"] = fav
    }
    
    func initFavFamilyNightActivities() {
        
        let fav = InterestCategories()
        
        fav.key = "activity-family-night"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Activities" {
                
                return true
            }
            
            return false
        }
        
        fav.isDayTime = false
        fav.templateType = "family"
        fav.iconSuffix = "family"
        
        fav.categories = [

            YelpCategories.sharedInstance.find("Arcades"),
            YelpCategories.sharedInstance.find("Basketball Courts"),
            YelpCategories.sharedInstance.find("Batting Cages"),
            YelpCategories.sharedInstance.find("Beaches"),
            YelpCategories.sharedInstance.find("Bike Rentals"),
            YelpCategories.sharedInstance.find("Boating"),
            YelpCategories.sharedInstance.find("Bowling"),
            YelpCategories.sharedInstance.find("Cinema"),
            YelpCategories.sharedInstance.find("Go Karts"),
            YelpCategories.sharedInstance.find("Kids Activities"),
            YelpCategories.sharedInstance.find("Laser Tag"),
            YelpCategories.sharedInstance.find("Mini Golf"),
            YelpCategories.sharedInstance.find("Museums"),
            YelpCategories.sharedInstance.find("Parks"),
            YelpCategories.sharedInstance.find("Planetarium"),
            YelpCategories.sharedInstance.find("Playgrounds"),
            YelpCategories.sharedInstance.find("Sledding"),
            YelpCategories.sharedInstance.find("Soccer"),
            YelpCategories.sharedInstance.find("Tennis"),
            YelpCategories.sharedInstance.find("Tubing")
        ]
        
        groups["Family Night Time"] = fav
    }
    
    func initFavOutdoorActivities() {
        
        let fav = InterestCategories()
        
        fav.key = "activity-outdoor"
        
        fav.matchAnyOfActivityType = { type in
            
            if type == "Activities" {
                
                return true
            }
            
            return false
        }
        
        fav.templateType = "outdoor"
        fav.iconSuffix = "outdoor"
        
        fav.categories = [
         
            YelpCategories.sharedInstance.find("Active Life"),
            YelpCategories.sharedInstance.find("Basketball Courts"),
            YelpCategories.sharedInstance.find("Batting Cages"),
            YelpCategories.sharedInstance.find("Beaches"),
            YelpCategories.sharedInstance.find("Bike Rentals"),
            YelpCategories.sharedInstance.find("Boating"),
            YelpCategories.sharedInstance.find("Botanical Gardens"),
            YelpCategories.sharedInstance.find("Campgrounds"),
            YelpCategories.sharedInstance.find("Castles"),
            YelpCategories.sharedInstance.find("Climbing"),
            YelpCategories.sharedInstance.find("Fishing"),
            YelpCategories.sharedInstance.find("Go Karts"),
            YelpCategories.sharedInstance.find("Golf"),
            YelpCategories.sharedInstance.find("Hiking"),
            YelpCategories.sharedInstance.find("Horse Racing"),
            YelpCategories.sharedInstance.find("Lakes"),
            YelpCategories.sharedInstance.find("Mini Golf"),
            YelpCategories.sharedInstance.find("Parks"),
            YelpCategories.sharedInstance.find("Sledding"),
            YelpCategories.sharedInstance.find("Soccer"),
            YelpCategories.sharedInstance.find("Tennis"),
            YelpCategories.sharedInstance.find("Tubing"),
            YelpCategories.sharedInstance.find("Zoos")
        ]
        
        groups["Outdoor"] = fav
    }
}