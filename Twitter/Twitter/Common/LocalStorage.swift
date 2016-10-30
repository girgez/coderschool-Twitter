//
//  LocalStorage.swift
//  Twitter
//
//  Created by Girge on 10/30/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class LocalStorage {
    static let shared = LocalStorage()
    
    private let defaults = UserDefaults.standard
    private let userKey = "user"
    private let accessTokenKey = "accessToken"
    
    func saveUser(user: User?) {
        if let user = user {
            let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
            defaults.set(data, forKey: userKey)
        } else {
            defaults.set(nil, forKey: userKey)
        }
        defaults.synchronize()
    }
    
    func loadUser() -> User? {
        var user: User?
        if let data = defaults.object(forKey: userKey) as? Data {
            let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
//            print(dictionary)
            user = User(dictionary: dictionary)
        }

        return user
    }
    
    func saveAccessToken(accessToken: BDBOAuth1Credential?) {
        if let accessToken = accessToken {
            let data = NSKeyedArchiver.archivedData(withRootObject: accessToken)
            defaults.set(data, forKey: accessTokenKey)
        } else {
            defaults.set(nil, forKey: accessTokenKey)
        }
        defaults.synchronize()
    }
    
    func loadAccessToken() -> BDBOAuth1Credential? {
        var accessToken: BDBOAuth1Credential?
        if let data = defaults.object(forKey: accessTokenKey) as? Data {
            accessToken = NSKeyedUnarchiver.unarchiveObject(with: data) as? BDBOAuth1Credential
        }
        
        return accessToken
    }
}
