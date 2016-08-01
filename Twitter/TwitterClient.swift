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
    
    
    func postTweet(composeTweet: String){
//        var params = Dictionary<String, String>()
        
        var params : [String : String] = [:]
        params["status"] = composeTweet
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("success posting tweet")
            print("response from success of tweet : \(response)")
        },failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("task : \(task)")
                print("Error posting tweet : \(error.localizedDescription)")
        })
    }
    
    func homeTimeline(success:([Tweet]) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
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
