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
    static var shared = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "8pheut7KeZ4uUk9f4Rgij0BhI", consumerSecret: "7Fly9qwg3XbjR80wmnwyFrS7wbVw6yGGSWjPFmdiWfKIkOCeAK")!
    
    private var _accessToken: BDBOAuth1Credential?
    var accessToken: BDBOAuth1Credential? {
        get{
            if _accessToken == nil {
                _accessToken = LocalStorage.shared.loadAccessToken()
                if let at = _accessToken, !at.isExpired {
                    requestSerializer.saveAccessToken(_accessToken)
                } else {
                    _accessToken = nil
                }
            }
            return _accessToken
        }
        set(new){
            _accessToken = new
            LocalStorage.shared.saveAccessToken(accessToken: _accessToken)
        }
    }
    
    private var loginSuccess: (() -> Void)?
    private var loginFailure: ((Error) -> Void)?
    
    func login(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitter://oauth"), scope: nil, success: { (token) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }, failure: { (error) in
            failure(error!)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (access_token) in
            print("\(access_token?.secret)\n\(access_token?.token)")
            self.accessToken = access_token
            self.loginSuccess?()
        }) { (error) in
            self.loginFailure?(error!)
        }
    }
    
    func homeTimeline(count: Int?, maxId: Int?,success: @escaping ([Tweet]) -> Void, failure: ((Error) -> Void)? = nil) {
        
        var parameters = [String : AnyObject]()
        
        parameters["exclude_replies"] = true as AnyObject
        
        if count != nil {
            parameters["count"] = count! as AnyObject
        } else {
            parameters["count"] = 22 as AnyObject
        }
        
        if maxId != nil {
            parameters["max_id"] = maxId! as AnyObject
        }
        
        print(parameters)
        
        get("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task, response) in
            let tweets: [Tweet]
            if let dictionaries = response as? [NSDictionary] {
                print(dictionaries)
                tweets = Tweet.tweetsArray(dictionarys: dictionaries)
            } else {
                tweets = [Tweet]()
            }
            
            success(tweets)
        }) { (task, error) in
            print("home timeline failed \(error.localizedDescription)")
            failure?(error)
        }
    }

    func currentAccount(success: @escaping (User) -> Void) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }) { (task, error) in
            self.loginFailure?(error)
        }
    }
    
    // like
    func likeTweet(id: Int, success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        
        var parameters = [String : AnyObject]()
        parameters["id"] = id as AnyObject
        
        post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task, response) -> Void in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task, error) -> Void in
                print("like tweet error: \(error.localizedDescription)")
                failure?(error)
        })
    }
    
    func unLikeTweet(id: Int, success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        
        var parameters = [String : AnyObject]()
        parameters["id"] = id as AnyObject
        
        post("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task, response) -> Void in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task, error) -> Void in
                print("unlike tweet error: \(error.localizedDescription)")
                failure?(error)
        })
    }
    
    // retweet
    func retweet(id: Int, success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task, response) -> Void in
            
            let dictionary = response as! NSDictionary
            print(dictionary)
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task, error) -> Void in
                print("retweet error: \(error.localizedDescription)")
                failure?(error)
        })
    }
    
    func unRetweet(id: Int, success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task, response) -> Void in
            
            let dictionary = response as! NSDictionary
            print(dictionary)
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task, error) -> Void in
                print("unretweet error: \(error.localizedDescription)")
                failure?(error)
        })
    }
    
    // new tweet
    func newTweet(text: String, replyId: Int?, success: @escaping (Tweet) -> Void, failure: ((Error) -> Void)? = nil) {
        var parameters = [String: AnyObject]()
        parameters["status"] = text as AnyObject
        
        if let replyId = replyId {
            parameters["in_reply_to_status_id"] = replyId as AnyObject
        }
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task, response) -> Void in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            
            }, failure: { (task, error) -> Void in
                print("retweet error: \(error.localizedDescription)")
                failure?(error)
        })
    }
}
