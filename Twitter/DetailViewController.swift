//
//  DetailViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/31/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailedNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var detailedImageLabel: UIImageView!
    @IBOutlet weak var reTweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoritesImage: UIButton!

    
    var tweet : Tweet!
//            if tweet.favorited == 0{
//                favoritesImage.alpha = 0.5
//            }else{
//                favoritesImage.alpha = 1
//            }
//            print(tweet.name)
    
//            userScreenNameWhoPosted = tweet.userScreenNameWhoPosted as? String
//            tweetID = tweet.tweetID as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailedNameLabel.text = tweet.name as? String
        tweetLabel.text = tweet.text as? String
        favoritesLabel.text = "\(tweet.favoritesCount)"
        reTweetLabel.text = "\(tweet.retweetCount)"
        
        screenNameLabel.text = tweet.screenName as? String
        detailedImageLabel.setImageWithURL(tweet.imageUrl!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
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
