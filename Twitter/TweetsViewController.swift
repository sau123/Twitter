//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/29/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets : [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            //reload data
            for tweet in tweets{
                print("tweet text : ",tweet.text)
                print("tweet fav count : ", tweet.favoritesCount)
                print("tweet  timestamp : ", tweet.timestamp)
                print("tweet recount : ",tweet.retweetCount)
                print()
            }
            
        }) { (error: NSError) -> () in
            print("error : \(error.localizedDescription)")
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count is saumeel: ",self.tweets?.count)
        return self.tweets?.count ?? 0
//        if self.tweets != nil {
//            return self.tweets!.count
//        }else{
//            return 0
//        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        var row = indexPath.row
        cell.tweetTextLabel.text = tweets[row].text
        cell.favoritesCountLabel.text = tweets
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout() 
        
        dismissViewControllerAnimated(true, completion: nil)
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
