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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
