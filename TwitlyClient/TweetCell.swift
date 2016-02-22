//
//  TweetCell.swift
//  TwitlyClient
//
//  Created by Zubair Khan on 2/21/16.
//  Copyright © 2016 zapps. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            let user = tweet.user!
            nameLabel.text = user.name
            usernameLabel.text = user.screenname
            //retweetTextLabel.text = tweet.
            tweetTextLabel.text = tweet.text

            let profileImageURL = NSURL(string: user.profileImageUrl)
            profileImage.setImageWithURL(profileImageURL!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
