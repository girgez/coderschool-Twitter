//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Girge on 10/29/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        loadTweet()
    }

    func loadTweet() {
        TwitterClient.shared.homeTimeline(count: nil, maxId: nil, success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTweetSegue" {
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! NewTweetViewController
            vc.delegate = self
        }
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
//        cell.set(tweet: tweets[indexPath.row])
        cell.tweet = tweets[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension TweetsViewController: TweetCellDelegate {
    func tweetCell(cell: TweetCell) {
        tweets[cell.index].isFavorited = cell.tweet.isFavorited
        tweets[cell.index].favoritesCount = cell.tweet.favoritesCount
//        tableView.reloadRows(at: [IndexPath(row: cell.index, section: 0)], with: .none)
    }
}

extension TweetsViewController: NewTweetViewControllerDelegate {
    func newTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}
