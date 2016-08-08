//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 8/7/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit
import SVPullToRefresh


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet]?

    
    
    func getTimeLineTweets(count: String?){
        TwitterClient.sharedInstance.userTimeline(count, success: { (tweets: [Tweet]) -> () in
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
        
        print("viewDidLoad, ProfileViewController")

        tableView.delegate = self
        tableView.dataSource = self
        refreshControlInit()
        self.getTimeLineTweets("\(6)") // for now, intially table will have 6 cells
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }

    
//    @IBAction func onBackTap(sender: AnyObject) {
//        print("on back tap")
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
