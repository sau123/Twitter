//
//  TwitterClient.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/28/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "tSsITTzUmYMINwQfL0H4jiOHI", consumerSecret: "kMA1Vp9cn28boG76T0cKOoc9FvGxgNbFN1PuVfBoMKhxJXEzxH")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    //    func closureTest(completion : ()->()) {
    //    // 50 sec block
    //
    //    }
    
    //    func closureTestWith2Params(success: ()->(), failure : (error : NSError)->()) {
    ////        let isSuccess : Bool = true
    ////        // some logic that isSuccess
    ////        let error : NSError()
    ////        if isSuccess {
    ////            success()
    ////        } else {
    ////            failure(error)
    ////        }
    ////
    //    }
    func login(success: () -> (), failure: (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("/oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterDemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            
        }) {(error: NSError!) -> Void in
            print("error : \(error.localizedDescription)")
            print("saved error !")
            self.loginFailure?(error)
        }
    }
    
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user : User) -> () in
                //                User._currentUser = user
                User.currentUser = user
                print("_currentUser set")
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
        }) {(error: NSError!) -> Void in
            print("Error : \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    //    func homeTimeline(success:([Tweet]) -> (), failure: (NSError) -> ()) {
    
    
    func postTweet(composeTweet: String, replyToTweetId: String, success: (Tweet) -> (), failure: (NSError) -> ()){
        var params : [String : String] = [:]
        params["status"] = composeTweet
        params["in_reply_to_status_id"] = replyToTweetId
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("success posting tweet")
            print("response from success of tweet : \(response)")
            
            let dictionry = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionry)
            success(tweet)
            },failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error posting tweet : \(error.localizedDescription)")
                failure(error)
        })
    }
    //https://api.twitter.com/1.1/statuses/retweet/760168682102353920.json
    func reTweet(tweetId: String, success: () -> (), failure: (NSError) -> ()){
        //        var params : [String:String] = [:]
        //        params["id"] = tweetId
        POST("/1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("sucess retweeting!")
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error while retweeting : \(error.localizedDescription)")
                failure(error)
        })
        
    }
    
    func unRetweet(tweetId: String, success: () -> (), failure: (NSError) -> ()){
        POST("/1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("success unretweeting")
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error while unretweeting : \(error.localizedDescription)")
                failure(error)
        })
        
    }
    
    
    func favoriteTweet(tweetId: String, success: () -> (), failure: (NSError) -> ()){
        var params : [String: String] = [:]
        params["id"]=tweetId
        POST("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("success favorting the  tweet")
            print("response after favoriting the tweet : \(response)")
            
            success()
            },failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error while favoriting the tweet : \(error.localizedDescription)")
                print("make a request for defavoriting")
                failure(error)
        })
    }
    
    func deFavoriteTweet(tweetId: String, success: () -> (), failure: (NSError) -> ()){
        var params : [String: String] = [:]
        params["id"] = tweetId
        POST("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("success defavorting the  tweet")
            print("response after defavoriting the tweet : \(response)")
            success()
            },failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error while defavoriting the tweet : \(error.localizedDescription)")
                failure(error)
        })
    }
    
    
    func homeTimeline(count : String?, success:([Tweet]) -> (), failure: (NSError) -> ()) {
        
        print("count of tweets : \(count)")
        var params : [String : String] = [:]
        if count != nil{
            params["count"] = "\(count!)"
        }else{
            params["count"] = "\(5)"
        }
        
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            print("Ressponse :",response)
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:  AnyObject?) -> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            //
            //            print("name : \(user.name)")
            //            print("screen name : \(user.screenname)")
            //            print("profile image url : \(user.profileUrl)")
            //            print("description : \(user.tagline)")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
}
