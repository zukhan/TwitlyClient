//
//  TwitterClient.swift
//  TwitlyClient
//
//  Created by Zubair Khan on 2/21/16.
//  Copyright © 2016 zapps. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "LrW3obvCSGGKliSP4W3RQ1BeK"
let twitterConsumerSecret = "FpFOsZhpK2HyL20UhVhOVVejYufUFDJDKrzzKzDyhHHUIpwHiW"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }

    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        GET(
            "1.1/statuses/home_timeline.json",
            parameters: nil, progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
            })
    }

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion

        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("got the request token")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(authURL)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
            }
    }

    func openURL(url: NSURL) {
        fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("got access token!")
                self.requestSerializer.saveAccessToken(accessToken)

                self.GET(
                    "1.1/account/verify_credentials.json",
                    parameters: nil, progress: nil,
                    success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        self.loginCompletion?(user: user, error: nil)
                    }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                        self.loginCompletion?(user: nil, error: error)
                    })



            }) { (error: NSError!) -> Void in
                print("Failed to get access token")
                self.loginCompletion?(user: nil, error: error)
            }
    }

}
