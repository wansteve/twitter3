//
//  TwitterClient.swift
//  Twitter
//
//  Created by Steve Wan on 5/20/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit


//let twitterConsumerKey = "aHPyNejHHQSceTrKvUoludMbx"
//let twitterConsumerSecret = "g3e2jQZdp0OHbWzv1fXbU8Zp0JCq26m8uWmVp5KbHWcDq4MkgM"

let twitterConsumerKey = "jc6XmTRyCQkC4ogE4fa2OEqzL"
let twitterConsumerSecret = "M0lDng9LwKfikAoi54hXtgNDd6IpkQqns31hftYIgnH3ko4ny3"

// let twitterConsumerKey = "Zwi6PYVjgkXwXhodsla7jVaz9"
// let twitterConsumerSecret = "DCtIS3p2kgslg7vqBAWXqzTPvejfhy5KPTm91yhiAapa3acSqv"

// testing

let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())? // hold the closure till ready to use it
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
             println("home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary]) // standard way of extracting from an array of dictionary to array of tweets is that initialize an array of tweets with an array of dictionary
            
            completion(tweets: tweets, error: nil)
            
            
            for tweet in tweets {
                println("text: \(tweet.text) created: \(tweet.createdAt)")
            }
            
            
            
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to getting home timeline \(error)")
                completion(tweets: nil, error: error)

        })
        
        
    } // homeTimeLineWithParams
    
    
    func postStatusUpdateWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error posting status update")
                completion(tweet: nil, error: error)
        }
    }
    
    
    // retweet
    func retweetWithParams(params: NSDictionary?, msgid: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/statuses/retweet/\(msgid).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error retweeting1")
                completion(tweet: nil, error: error)
        }
    }
    
   
    // reply
    func replyWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/statuses/retweet/241259202004267009.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error replying1")
                completion(tweet: nil, error: error)
        }
    }
    
 
    // favorite
    func favoriteWithParams(params: NSDictionary?, msgid: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        
        self.POST("1.1/favorites/create.json?id=\(msgid)", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error favoriting1")
                completion(tweet: nil, error: error)
        }
    }
    
    
    
    
    
    
    // a func which takes a completion block or closure (user, error) and returns nothing
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ())
    {
    loginCompletion = completion
        
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: { (request_token: BDBOAuth1Credential!) in
                println("Got request token: \(request_token)")
                let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request_token.token)")!
                UIApplication.sharedApplication().openURL(authUrl)
            },
            failure: { (error: NSError!) in
                println("Error getting request token: \(error)")
                self.loginCompletion?(user:nil, error: error) // tells the caller error happens
            }
        )
    } // loginWithCompletion
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: {(accessToken: BDBOAuth1Credential!) ->
            Void in
            println("Got the access token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                // println("user: \(response)")
                
                var user = User(dictionary: response as! NSDictionary) // init User with the dictionary returned by verify_credentials.json
                User.currentUser = user
                println("user: \(user.name)")
                self.loginCompletion?(user:user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("Failed to getting current user")
                    self.loginCompletion?(user:nil, error: error)

            })
            
            
            }) { (error: NSError!) -> Void in
                println("Failed to receive access token")
                self.loginCompletion?(user:nil, error: error)

        }
        
    } // openURL
    
}
