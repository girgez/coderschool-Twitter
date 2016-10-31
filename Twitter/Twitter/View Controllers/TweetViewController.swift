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
}

extension TweetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.inTweetViewController = true
        cell.tweet = tweet
        cell.index = indexPath.row
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
}
