//
//  Tweet.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/28/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit
import SwiftyJSON

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var screenName: NSString? //@ShaneWarne
    var name: NSString? // Shane Warne
    var imageUrl: NSURL?
    var tweetID: NSString?
    var userScreenNameWhoPosted: NSString?
    var favorited: Int?
    var duration: String?
    
    var followersCount: Int? = 0
    var followingCount: Int? = 0
    var tweetsCount: Int? = 0
    
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        screenName = dictionary["user"]!["screen_name"] as? String
        name = dictionary["user"]!["name"] as? String
        favorited = dictionary["favorited"] as? Int
        
        userScreenNameWhoPosted = dictionary["user"]!["screen_name"] as? String
        tweetID = dictionary["id_str"] as? String
        
        let imageString = dictionary["user"]!["profile_image_url_https"] as? String
        imageUrl = NSURL(string: imageString!)
        
        followersCount = (dictionary["user"]!["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["user"]!["friends_count"] as? Int) ?? 0
        tweetsCount = (dictionary["user"]!["statuses_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        let dateMakerFormatter = NSDateFormatter()
        let userCalendar = NSCalendar.currentCalendar()
        
        dateMakerFormatter.dateFormat = "yyyy/MM/dd hh:mm a Z"
        let endTime = NSDate()
        let hourMinuteSecondsComponents: NSCalendarUnit = [.Hour, .Minute, .Second]
        let timeDifference = userCalendar.components(
            hourMinuteSecondsComponents,
            fromDate: timestamp!,
            toDate: endTime,
            options: [])
        
        var hr : String = ""
        if timeDifference.hour > 0 {
            if timeDifference.hour == 1{
                hr = "\(timeDifference.hour)hr"
            }
            if timeDifference.hour > 1{
                hr += "s"
            }
        }
        
        let min : String = ""
        if timeDifference.minute > 0 {
                hr = "\(timeDifference.minute)m"
        }
        
        let sec : String = ""
        if timeDifference.second > 0 {
            hr = "\(timeDifference.second)s"
        }
        
        print("time : \(hr)\(min)\(sec)")
        self.duration = "\(hr)\(min)\(sec)"
        
        if "\(hr)\(min)\(sec)".isEmpty {
            self.duration = "1s"
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
