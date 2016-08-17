//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 8/7/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit
import SVPullToRefresh

@objc protocol TableCellButtonsDelegate: class{
    optional func getFavorites(profileCell: ProfileCell, getFavorites tweetID: String)
    
    optional func postRetweet(profileCell: ProfileCell, postTweets tweetID: String)

    optional func replyToTweet(profileCell: ProfileCell, replyTweet tweetID: String)
    
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableCellButtonsDelegate, UIScrollViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var delegate: ComposeViewControllerDelegate?
    var tweets : [Tweet]? = []
    var tweet : Tweet?
    var user : User?
    
    @IBOutlet weak var headerView: UIView!
    
    var userScreenName : String?
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrolled.")
    }
    
    
    //implementation of favorites delegate
    func getFavorites(profileCell: ProfileCell, getFavorites tweetID: String){
        print("in profile view controller, got details from profilecell to profile VC")
        TwitterClient.sharedInstance.favoriteTweet(tweetID, success: {
            self.tableView.triggerPullToRefresh()
//            self.tableView.reloadData()

            //reload mayb!
        }) { (error: NSError) in
            print("Error in getFavorites implementation : \(error.code)")
            
            //make a network call to defavorite
            TwitterClient.sharedInstance.deFavoriteTweet(tweetID, success: {
                self.tableView.triggerPullToRefresh()
//                self.tableView.reloadData()
                }, failure: { (error: NSError) in
            })
        }
    }
    
    //implementation of retweet delegate
    func postRetweet(profileCell: ProfileCell, postTweets tweetID: String) {
        TwitterClient.sharedInstance.reTweet(tweetID, success: { 
            self.tableView.triggerPullToRefresh()
//            self.tableView.reloadData()
        }) { (error: NSError) in
                TwitterClient.sharedInstance.unRetweet(tweetID, success: { 
                    self.tableView.triggerPullToRefresh()
//                    self.tableView.reloadData()
                    }, failure: { (erro: NSError) in
                })
        }
    }
    
    
    // if userid is nil, implies loggedIn user, else image tapped in tweetsVC
    func getTimeLineTweets(count: String?, userID: String?){
        if userID == nil{
            userScreenName = (User.currentUser?.screenname as! String)
            
        }
        TwitterClient.sharedInstance.userTimeline(count, userId: userScreenName!,success: { (tweets: [Tweet]) -> () in
            print("refreshing")
            self.tweets = tweets
            self.setView()
            self.tableView.reloadData()
            
        }) { (error: NSError) -> () in
            print("error : \(error.localizedDescription)")
        }
    }
    
    func refreshControlInit(){
        self.tableView.addPullToRefreshWithActionHandler {
            print("pulled!")
            let count = self.tweets?.count
            self.getTimeLineTweets("\(count)", userID: self.userScreenName)
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()

            self.tableView.pullToRefreshView.stopAnimating()
            
        }
        
        self.tableView.addInfiniteScrollingWithActionHandler {
            var size = self.tweets!.count
            size += 5;
            print("infinite scroll pulled : \(size)")
            
            self.getTimeLineTweets("\(size)", userID: self.userScreenName)
            self.tableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    func setView(){
        profileImageView.setImageWithURL((user?.profileUrl!)!)
        screenNameLabel.text = user?.screenname as? String
        fullNameLabel.text = user?.name as? String
        followersCountLabel.text = "\(user!.followersCount!)"
        followingCountLabel.text = "\(user!.followingCount!)"
        tweetCountLabel.text = "\(user!.tweetsCount!)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scrollView = UIScrollView(frame: headerView.bounds)
        scrollView.delegate = self
        headerView.addSubview(scrollView)
        
        
        print("viewDidLoad, ProfileViewController")
        print(userScreenName)
        print("printed user id")
        
        if userScreenName == nil {
            user = User.currentUser
        }
        
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        refreshControlInit()
        self.getTimeLineTweets("\(6)", userID: self.userScreenName) // for now, intially table will have 6 cells
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        cell.tweet = tweets![indexPath.row]
        cell.delegate = self
        return cell
    }

    
}
