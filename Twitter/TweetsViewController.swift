//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Steve Wan on 5/23/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit

struct TwitterEvents {
    static let TweetPosted = "TweetPosted"
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        println("viewdidload")
        
        NSNotificationCenter.defaultCenter().addObserverForName(TwitterEvents.TweetPosted, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            let tweet = notification.object as! Tweet
            self.tweets?.insert(tweet, atIndex: 0)
            self.tableView.reloadData()
        }
        
        loadStatuses()
        
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
             self.tweets = tweets
            
            // initialize tableview with the following 2 lines
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 120
            
            
            
        })
    } // viewDidLoad
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("viewdidappear")
        
        
        self.tableView.addPullToRefreshWithActionHandler {
            TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets , error) -> () in
                self.loadStatuses()
            })
        } // PulltoRefresh 
        
        
    } // viewDidAppear
    

    
    func loadStatuses() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            
            
            // pull to refresh
            if self.tableView.pullToRefreshView != nil {
                self.tableView.pullToRefreshView.stopAnimating()
            }
            
            
            self.tweets = tweets
            self.tableView.reloadData()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                return ()
            })
        })
    }
    
    
    // delegate 2
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TweetsTableViewCell") as! TweetsTableViewCell
        cell.tweet = self.tweets?[indexPath.row]
        return cell
    }
    
    // for SingleTweetViewController
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SingleTweetViewController") as! SingleTweetViewController
        controller.tweet = self.tweets![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        println("pushViewController: singletweetviewcontroller")
        
        // self.performSegueWithIdentifier("SingleTweetSegue", sender: self)

    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    
    // delegate 1
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
    
    User.currentUser?.logout()
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
