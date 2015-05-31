//
//  SingleTweetViewController.swift
//  Twitter
//
//  Created by Steve Wan on 5/24/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var retweetNumberLabel: UILabel!
    
    @IBOutlet weak var favoriteNumberLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.navigationItem.title = "Tweet"
        
        self.profileImage.setImageWithURL(self.tweet?.user!.profileImageUrl)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        self.nameLabel.text = self.tweet?.user!.name
        self.screennameLabel.text = self.tweet!.user!.screenname
        self.tweetTextLabel.text = self.tweet?.text
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm aaa"
        // self.dateLabel.text = formatter.stringFromDate(self.tweet?.createdAt!)
        self.dateLabel.text = "\(self.tweet!.createdAt!.timeAgo()) ago"
        // self.timeLabel.text = newValue?.createdAt!.timeAgo()

        
         //self.retweetNumberLabel.text = "\(self.tweet?.numberOfRetweets)"
         //self.favoriteNumberLabel.text = "\(self.tweet?.numberOfFavorites)"
        
        // self.dateLabel.text = "12 min ago"
        //self.retweetNumberLabel.text = "Retweet Number"
        //self.favoriteNumberLabel.text = "Favorite Number"
        
    }

    @IBAction func onReplyTap(sender: AnyObject) {
        
        TwitterClient.sharedInstance.replyWithParams(nil, completion: { (tweet, error) -> () in
            if error != nil {
                NSLog("error replying2: \(error)")
                return
            }
        
        })
    }
    
    
    @IBAction func onFavoriteTap(sender: AnyObject) {

        
        println("favorite tweet ID is \(self.tweet?.id)")
        var msgid = self.tweet?.id
        
        TwitterClient.sharedInstance.favoriteWithParams(nil, msgid: msgid!, completion: { (tweet, error) -> () in
            if error != nil {
                NSLog("error favoriting2: \(error)")
                return
            }
        })
    
    }// onFavoriteTap
    
    
    @IBAction func onRetweetTap(sender: AnyObject) {
    
        println("retweet tweet ID is \(self.tweet?.id)")
        var msgid = self.tweet?.id
        
        TwitterClient.sharedInstance.retweetWithParams(nil, msgid: msgid!, completion: { (tweet, error) -> () in
            if error != nil {
                NSLog("error retweeting2: \(error)")
                return
            }
            // NSNotificationCenter.defaultCenter().postNotificationName(TwitterEvents.TweetPosted, object: status)

        })
        
 
    }// onRetweetTap
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
