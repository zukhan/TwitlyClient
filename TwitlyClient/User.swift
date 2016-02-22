//
//  User.swift
//  TwitlyClient
//
//  Created by Zubair Khan on 2/21/16.
//  Copyright © 2016 zapps. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "keyCurrentUser"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String
    var screenname: String
    var profileImageUrl: String
    var tagline: String
    var dictionary: NSDictionary

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as! String
        screenname = dictionary["screen_name"] as! String
        profileImageUrl = dictionary["profile_image_url"] as! String
        tagline = dictionary["description"] as! String
    }

    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                var dictionary: NSDictionary?
                if let data = data {
                    do {
                        dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                        _currentUser = User(dictionary: dictionary!)
                    } catch {
                        print("error serializing")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user

            var data: NSData? = nil
            if let user = user {
                do {
                    data = try NSJSONSerialization.dataWithJSONObject(user.dictionary, options: []) as NSData
                } catch {
                    print("error persisting user")
                }
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

}
