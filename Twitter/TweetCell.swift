//
//  TweetCell.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/31/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var reTweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favouriteImage: UIButton!
    
    var tweetID : String?
    var userScreenNameWhoPosted: String?
    weak var delegate: ButtonsDelegate? //replydelegate
    weak var favoritesDelegate: FavoritesDelegate?
    weak var retweetDelegate: RetweetDelegtate?
    
    var tweet : Tweet! {
        didSet{
//            favouriteImage.alpha = 0.5
            if tweet.favorited == 0{
                favouriteImage.alpha = 0.5
            }else{
                favouriteImage.alpha = 1
            }
            print(tweet)
            fullNameLabel.text = tweet.name as? String
            tweetTextLabel.text = tweet.text as? String
            favoritesCountLabel.text = "\(tweet.favoritesCount)"
            reTweetCountLabel.text = "\(tweet.retweetCount)"
            fullNameLabel.text = tweet.name as? String
            screenNameLabel.text = tweet.screenName as? String
            profileImageView.setImageWithURL(tweet.imageUrl!)
            
            userScreenNameWhoPosted = tweet.userScreenNameWhoPosted as? String
            tweetID = tweet.tweetID as? String
            dateLabel.text = tweet.duration
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func retweetButtonTapped(sender: AnyObject){
        print("tapped retweetButtonTapped")
        retweetDelegate?.postRetweet!(self, postRetweets: tweetID!)
    }
    
    @IBAction func favoritesButtonTapped(sender: AnyObject){
        print("tapped favoritesButtonTapped")
        favoritesDelegate?.getFavorites!(self, getFavorites: tweetID!)
    }
    
    @IBAction func replyButtonTapped(sender: AnyObject) {
        print("tapped replyButtonTapped")
        
        delegate?.getTweetDetails!(self, tweetDetails: tweetID!, userScreenNameWhoPosted: userScreenNameWhoPosted!)
    }

}
