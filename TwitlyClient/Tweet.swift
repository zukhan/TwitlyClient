//
//  Tweet.swift
//  TwitlyClient
//
//  Created by Zubair Khan on 2/21/16.
//  Copyright © 2016 zapps. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var isRetweet: Bool?
    var id: Int?
    var favoriteCount: Int?
    var retweetCount: Int?
    var inReplyToTweetId: String?

    init(dictionary: NSDictionary){
        if let userDictionary = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDictionary)
        }

        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)!

        id = dictionary["id"] as? Int
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        inReplyToTweetId = dictionary["in_reply_to_status_id"] as? String

        if let retweet = dictionary["retweeted"] as? Int {
            isRetweet = (retweet != 0)
        }
    }

    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
