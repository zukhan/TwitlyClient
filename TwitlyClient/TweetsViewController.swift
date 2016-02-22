//
//  TweetsViewController.swift
//  TwitlyClient
//
//  Created by Zubair Khan on 2/21/16.
//  Copyright © 2016 zapps. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        refreshControlAction(refreshControl)
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        if let vc = segue.destinationViewController as? TweetDetailViewController {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            vc.tweet = self.tweets![indexPath!.row]
        } else
        */
        if let vc = segue.destinationViewController as? ComposeViewController {
        }
    }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        if let tweets = tweets {
            cell.tweet = tweets[indexPath.row]
        }
        return cell
    }
}
