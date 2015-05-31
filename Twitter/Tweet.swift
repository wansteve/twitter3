//
//  Tweet.swift
//  Twitter
//
//  Created by Steve Wan on 5/23/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text:String?
    var createdAtString: String?
    var createdAt: NSDate?
    var numberOfFavorites:String?
    var numberOfRetweets:String?
    var id:String?
    
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary) // init class User with dictionary[User], dont forget to access dictionary using double quotes
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String // when you are not sure if the downcast will succeed. This form of the operator will always return an optional value, and the value will be nil if the downcast was not possible. This enables you to check for a successful downcast.
        
        numberOfRetweets = dictionary["retweet_count"] as? String
        numberOfFavorites = dictionary["favorite_count"] as? String
        id = dictionary["id_str"] as? String

        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!) // since createdAtString is an option type String, need to unwrap it to String first before passing to dateFromString
        

        
    } // init
    
    // create a func on the tweet class
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] // give it array, which is an array of dictionary and return an array of tweets
    {
        var tweets = [Tweet]() // declare an empty array of Tweet
        for  dictionary in array {
            tweets.append(Tweet(dictionary: dictionary)) // append to tweets by an instance of Tweet initialized by dictionary
        }
        
        return tweets
    }
}
