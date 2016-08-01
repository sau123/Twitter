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

@objc protocol ButtonsDelegate: class{
    optional func tweetIDPassed(tweetCell: TweetCell, tweetIDPassed tweetID: String)
}


class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonsDelegate {
    
    var _tweetID : String?
    var tweets : [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ComposeViewControllerDelegate?
    
    func tweetIDPassed(tweetCell: TweetCell, tweetIDPassed tweetID: String) {
        print("send this tweet to another view controller :\(tweetID)")
        _tweetID = tweetID
        
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
//        TwitterClient.sharedInstance.closureTestWith2Params({
//            <#code#>
//        }) { (error : NSError) in
//                code
//        }
        
        
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
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
            self.delegate = composeViewController
            
            delegate?.getTweetID!(self, tweetsIDPassed: _tweetID!)
            
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
    
}
