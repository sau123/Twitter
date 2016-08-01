//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/29/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit
import SVPullToRefresh

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets : [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    
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
        
        cell.retweetButton.addTarget(self, action: #selector(TweetCell.retweetButtonClicked(_:)), forControlEvents: .TouchUpInside)
        
        cell.tweet = tweets![indexPath.row]
        
        
        return cell
    }
    
    
    @IBAction func favoritesTapped(sender: AnyObject) {
        print("favorite button tapped!")
        print(sender)
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
            let filtersViewController = navigationController.topViewController as! ComposeViewController
            
        }
        
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
    
}
