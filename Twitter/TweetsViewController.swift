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


class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonsDelegate, FavoritesDelegate{
    
    var _tweetID : String?
    var _userScreenNameWhoPosted: String?
    var tweets : [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ComposeViewControllerDelegate?
    
    
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
//        tableView.reloadData()
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
    
    func getTimeLineTweets(){
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            print("refreshing")
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) -> () in
            print("error : \(error.localizedDescription)")
        }
    }
    func refreshControlInit(){
        tableView.addPullToRefreshWithActionHandler {
            self.getTimeLineTweets()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControlInit()
        self.getTimeLineTweets()
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
        return cell
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
            
            if _tweetID != nil{ // implies its a reply.
                delegate?.getTweetDetails!(self, tweetDetails: _tweetID!, userWhoPosted: _userScreenNameWhoPosted!)
                _tweetID = nil
            }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    }
    
}
