//
//  TweetViewController.swift
//  Twitter
//
//  Created by Girge on 10/31/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit

@objc protocol TweetViewControllerDelegate {
    func tweetViewController(viewController: TweetViewController)
    @objc optional func tweetViewController(reply viewController: TweetViewController)
}

class TweetViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    weak var delegate: TweetViewControllerDelegate!
    var indexTweet: Int!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReplySegue" {
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! NewTweetViewController
            vc.tweet = tweet
            vc.index = indexTweet
            vc.delegate = self
        }
    }
}

extension TweetViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tweet.reply.count > 0{
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return tweet.reply.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        if indexPath.section == 0{
            cell.inTweetViewController = true
            cell.tweet = tweet
            cell.index = indexPath.row
        } else {
            cell.inTweetViewController = true
            cell.tweet = tweet.reply[indexPath.row]
            cell.index = indexPath.row
        }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
extension TweetViewController: TweetCellDelegate {
    func tweetCell(cell: TweetCell) {
        tweet.isFavorited = cell.tweet.isFavorited
        tweet.favoritesCount = cell.tweet.favoritesCount
        tweet.isRetweeted = cell.tweet.isRetweeted
        tweet.retweetCount = cell.tweet.retweetCount
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        delegate.tweetViewController(viewController: self)
    }
    func tweetCell(reply cell: TweetCell) {
        performSegue(withIdentifier: "ReplySegue", sender: nil)
    }
}

extension TweetViewController: NewTweetViewControllerDelegate {
    func newTweet(tweet: Tweet) {
        // ko dung
    }
    func newTweet(reply: Tweet, index: Int) {
        print(tweet.dictionary)
        tweet.reply.append(reply)
        tableView.reloadData()
        delegate.tweetViewController?(reply: self)
    }
}
