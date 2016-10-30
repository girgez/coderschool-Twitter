//
//  User.swift
//  Twitter
//
//  Created by Girge on 10/28/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit

class User: NSObject {
    private static var _shared: User?
    static var shared: User? {
        get {
            if _shared == nil {
//                if let data = UserDefaults.standard.object(forKey: "user") as? Data {
//                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
//                    _shared = User(dictionary: dictionary)
//                }
                _shared = LocalStorage.shared.loadUser()
            }
            return _shared
        }
        set(new) {
            _shared = new
            LocalStorage.shared.saveUser(user: _shared)
//            let defaults = UserDefaults.standard
//            if let user = new {
//                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
//                defaults.set(data, forKey: "user")
//            } else {
//                defaults.set(nil, forKey: "user")
//            }
//            defaults.synchronize()
        }
    }
    
    var name: String?
    var screenname: String?
    var profileImageUrl: URL?
    var tagline: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        if let profileImageUrlString = dictionary["profile_image_url_https"] as? String {
            profileImageUrl = URL(string: profileImageUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
}
