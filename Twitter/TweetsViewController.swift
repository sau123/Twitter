//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/29/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit
import SVPullToRefresh


/*
Delegates
 */

// this is basically reply delegate
@objc protocol ButtonsDelegate: class{
    optional func getTweetDetails(tweetCell: TweetCell, tweetDetails tweetID: String, userScreenNameWhoPosted: String)
}

@objc protocol FavoritesDelegate: class{
    optional func getFavorites(tweetCell: TweetCell, getFavorites tweetID: String)
}

@objc protocol RetweetDelegtate: class{
    optional func postRetweet(tweetCell: TweetCell, postRetweets tweetID: String)
}

@objc protocol ComposedTweetDelegate: class{
    optional func composeTweet(tweet: Tweet)
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonsDelegate, FavoritesDelegate, RetweetDelegtate, ComposedTweetDelegate{
    
    var _tweetID : String?
    var _userScreenNameWhoPosted: String?
    var tweets : [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ComposeViewControllerDelegate?
    
    //implemenation of composed delegate
    func composeTweet(tweet: Tweet) {
        tweets?.insert(tweet, atIndex: 0)
        tableView.reloadData()
        // add the tweet to the tweets and reload.
    }
    
    //implementation of favorites delegate
    func getFavorites(tweetCell: TweetCell, getFavorites tweetID: String) {
        print("in tweets view controller, got details from tweetcell to tweets view controller")
        print("tweedID received : "+tweetID)
        TwitterClient.sharedInstance.favoriteTweet(tweetID, success: {
            self.tableView.triggerPullToRefresh()
            //reload mayb!
        }) { (error: NSError) in
                print("Error in getFavorites implementation : \(error.code)")
            
//                make a network call to defavorite
                TwitterClient.sharedInstance.deFavoriteTweet(tweetID, success: {
                    self.tableView.triggerPullToRefresh()
                    }, failure: { (error: NSError) in
                })
        }
    }
    
    // implementaion of retweet delegate
    func postRetweet(tweetCell: TweetCell, postRetweets tweetID: String) {
        print("in tweets view controller, got details from tweetcell to tweets view controller")
        print("tweetID received : "+tweetID)
        
        TwitterClient.sharedInstance.reTweet(tweetID, success: { 
            self.tableView.triggerPullToRefresh()
        }, failure: { (error: NSError) in
            print("error while retweeting : \(error.localizedDescription)")
            TwitterClient.sharedInstance.unRetweet(tweetID, success: { 
                self.tableView.triggerPullToRefresh()
                }, failure: { (error: NSError) in
            })
        })
        
    }
    
    //implementation of replyDelegate buttonsdelegate
    func getTweetDetails(tweetCell: TweetCell, tweetDetails tweetID: String, userScreenNameWhoPosted: String){
        print("in tweets view controller, got details from tweetcell to tweets view controller")
        print("tweedID received : "+tweetID)
        print("userScreenNameWhoPosted : "+userScreenNameWhoPosted)
        print()
        _tweetID = tweetID
        _userScreenNameWhoPosted = userScreenNameWhoPosted
        performSegueWithIdentifier("composeSegue", sender: UIButton())
        
    }
    
    func getTimeLineTweets(count: String?){
        TwitterClient.sharedInstance.homeTimeline(count, success: { (tweets: [Tweet]) -> () in
            print("refreshing")
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) -> () in
            print("error : \(error.localizedDescription)")
        }
    }
    func refreshControlInit(){
        self.tableView.addPullToRefreshWithActionHandler {
            print("pulled!")
            let count = self.tweets?.count
            self.getTimeLineTweets("\(count)")
        }
        
        self.tableView.addInfiniteScrollingWithActionHandler {
            var size = self.tweets!.count
            size += 5;
            print("infinite scroll pulled : \(size)")

            self.getTimeLineTweets("\(size)")
            self.tableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControlInit()
        self.getTimeLineTweets("\(6)") // for now, intially table will have 6 cells
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count is saumeel: ",self.tweets?.count)
        return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        cell.delegate = self
        cell.favoritesDelegate = self
        cell.retweetDelegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        performSegueWithIdentifier("detailsSegue", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
  
     // MARK: - Navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "composeSegue"{
            print("preparing compose segue !")
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
            self.delegate = composeViewController
            composeViewController.composeTweetDelegate = self
            
            if _tweetID != nil { // implies its a reply.
                delegate?.getTweetDetails!(self, tweetDetails: _tweetID!, userWhoPosted: _userScreenNameWhoPosted!)
                _tweetID = nil
            }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        }else if segue.identifier == "detailsSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailsViewController = navigationController.topViewController as! DetailViewController
            let tweetCell = sender as! TweetCell
            
            let index = tableView.indexPathForCell(tweetCell)
            print("cell at index clicked !",index?.row)
            detailsViewController.tweet = tweets![(index?.row)!]
            
        }
    
    }
    
}
