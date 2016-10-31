//
//  Tweet.swift
//  Twitter
//
//  Created by Girge on 10/28/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var text: String?
    var createdAt: Date?
    var retweetCount: Int?
    var favoritesCount: Int?
    var user: User?
    var isRetweeted = false
    var isFavorited = false
    var imageUrls = [URL]()
    var imageRatio = [CGFloat]()
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        if let timestampString = dictionary["created_at"] as? String {
            let timeFormater = DateFormatter()
            timeFormater.dateFormat = "EEE MMM d HH:mm:ss Z y" // Tue Aug 28 21:16:23 +0000 2012
            createdAt = timeFormater.date(from: timestampString)
        }
        
        retweetCount = dictionary["retweet_count"] as? Int! ?? 0
        favoritesCount = dictionary["favorite_count"] as? Int! ?? 0
        user = dictionary["user"] != nil ? User(dictionary: (dictionary["user"] as? NSDictionary)!) : nil
        isFavorited = (dictionary["favorited"] as? Bool!) ?? false
        isRetweeted = (dictionary["retweeted"] as? Bool!) ?? false
        
        if let media = dictionary.value(forKeyPath: "extended_entities.media") as? [NSDictionary] {
            for image in media {
                if let urlString = image["media_url_https"] as? String {
                    imageUrls.append(URL(string: "\(urlString):medium")!)
                    if let size = image.value(forKeyPath: "sizes.medium") as? NSDictionary {
                        imageRatio.append(CGFloat(size["w"] as! Int))
                        imageRatio.append(CGFloat(size["h"] as! Int))
                    }
                    
                }
            }
        }
    }
    
    func createdAtString(short: Bool = true) -> String {
        var secondLabel: String
        var minuteLabel: String
        var hourLabel: String
        var dayLabel: String
        
        if short {
            secondLabel = "s"
            minuteLabel = "m"
            hourLabel = "h"
            dayLabel = "d"
        } else {
            secondLabel = " seconds ago"
            minuteLabel = " mimutes ago"
            hourLabel = " hours ago"
            dayLabel = " days ago"
        }
        
        let min = 60
        let hour = min * 60
        let day = hour * 24
        let week = day * 7
        let year = day * 365
        let elapsedTime = Date().timeIntervalSince(createdAt!)
        let duration = Int(elapsedTime)
        
        if duration < min {
            return "\(duration)\(secondLabel)"
        } else if duration < hour {
            let minDur = duration / min
            return "\(minDur)\(minuteLabel)"
        } else if duration < day {
            let hourDur = duration / hour
            return "\(hourDur)\(hourLabel)"
        } else if duration < week {
            let dayDur = duration / day
            return "\(dayDur)\(dayLabel)"
        } else if duration < year {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dMMM"
            let dateString = dateFormatter.string(from: createdAt!)
            return dateString
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dMMM y"
            let dateString = dateFormatter.string(from: createdAt!)
            return dateString
        }
    }
    
    class func tweetsArray(dictionarys: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionarys {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
