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
    
    var tweet : Tweet! {
        didSet{
            fullNameLabel.text = tweet.name as? String
            tweetTextLabel.text = tweet.text as? String
            favoritesCountLabel.text = "\(tweet.favoritesCount)"
            reTweetCountLabel.text = "\(tweet.retweetCount)"
            fullNameLabel.text = tweet.name as? String
            screenNameLabel.text = tweet.screenName as? String
            profileImageView.setImageWithURL(tweet.imageUrl!)
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

        // Configure the view for the selected state
    }

}