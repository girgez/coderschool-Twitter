//
//  TwitterClient.swift
//  Twitter
//
//  Created by Girge on 10/28/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let shared = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "sBPz2h8wpW7ySsDzIgjATWQGo", consumerSecret: "TlIXtfKRdZz4SliaoucMXeOu7TTRjf01C2r7ttjPopL0BI4tch")
    
    private var loginSuccess: (() -> Void)?
    private var loginFailure: ((Error) -> Void)?
    
    func login(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitter://oauth"), scope: nil, success: { (token) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!.token)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }, failure: { (error) in
            failure(error!)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: nil, requestToken: requestToken, success: { (access_token) in
            self.loginSuccess?()
        }) { (error) in
            self.loginFailure?(error!)
        }
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsArray(dictionarys: dictionaries)
            success(tweets)
        }) { (task, error) in
            failure(error)
        }
    }

    func currentAccount() {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let user = response as! NSDictionary
            User.shared = User(dictionary: user)
        }) { (task, error) in
            print("get account error: \(error.localizedDescription)")
        }
    }
}
