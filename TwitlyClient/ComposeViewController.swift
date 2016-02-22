//
//  ComposeViewController.swift
//  TwitlyClient
//
//  Created by Zubair Khan on 2/21/16.
//  Copyright © 2016 zapps. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.setImageWithURL(NSURL(string: (User.currentUser!.profileImageUrl))!)
        nameLabel.text = User.currentUser!.name
        usernameLabel.text = "@" + User.currentUser!.screenname

        tweetTextView.text = ""
        tweetTextView.delegate = self
    }


    func textViewDidChange(textView: UITextView) {
        let text = textView.text as NSString
        let count = 140-text.length
        if count < 0 {
            charCountLabel.textColor = UIColor.redColor()
        } else {
            charCountLabel.textColor = UIColor.grayColor()
        }
        charCountLabel.text = String(count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweetAction(sender: AnyObject) {
        // save the tweet
    }

}
