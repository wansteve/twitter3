//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Steve Wan on 5/23/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetsTextLabel: UILabel!
    
    
    var tweet: Tweet? {
        willSet(newValue) {
            self.profileImage.setImageWithURL(newValue?.user!.profileImageUrl)
            self.nameLabel.text = newValue?.user!.name
            // self.screennameLabel.text = "@\(newValue!.user!.screenname)"
            self.screennameLabel.text = newValue!.user!.screenname
            self.tweetsTextLabel.text = newValue?.text
            self.timeLabel.text = newValue?.createdAt!.timeAgo()
            // self.timeLabel.text = newValue?.createdAt as! String
            // self.timeLabel.text = "13 min ago"
        }
    }
    
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
    
    
    @IBAction func onFavoriteTap(sender: AnyObject) {println("favorite tweet ID is \(self.tweet?.id)")
        var msgid = self.tweet?.id
        
        TwitterClient.sharedInstance.favoriteWithParams(nil, msgid: msgid!, completion: { (tweet, error) -> () in
            if error != nil {
                NSLog("error favoriting2: \(error)")
                return
            }
        })
        
    }// onFavoriteTap
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
