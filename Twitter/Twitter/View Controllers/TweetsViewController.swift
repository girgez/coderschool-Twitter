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
    let refreshControl = UIRefreshControl()
    var isLoadingMore = false
    var loadingMoreView: InfiniteScrollActivityView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // pull to refresh
        refreshControl.addTarget(self, action: #selector(loadTweet), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        // infinite scroll
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        tableView.tableFooterView = loadingMoreView
        loadingMoreView.startAnimating()
        
        loadTweet()
    }

    func loadTweet() {
        
        TwitterClient.shared.homeTimeline(count: nil, maxId: nil, success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadMoreTweet() {
        let maxId = tweets[tweets.count - 1].id! - 1
        TwitterClient.shared.homeTimeline(count: nil, maxId: maxId, success: { (tweets) in
            self.tweets += tweets
            self.isLoadingMore = false
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
        }) { (error) in
            self.isLoadingMore = false
            self.loadingMoreView!.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTweetSegue" {
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! NewTweetViewController
            vc.delegate = self
        } else if segue.identifier == "TweetSegue" {
            let vc = segue.destination as! TweetViewController
            vc.indexTweet = tableView.indexPathForSelectedRow?.row
            vc.tweet = tweets[vc.indexTweet]
            vc.delegate = self
        } else if segue.identifier == "ReplySegue" {
            let data = sender as! [AnyObject]
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! NewTweetViewController
            vc.tweet = data[0] as? Tweet
            vc.index = data[1] as? Int
            vc.delegate = self
        }
    }
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.shared.requestSerializer.removeAccessToken()
        User.shared = nil
        Common.setRootView(vcIdentifier: "LoginViewController")
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
//        cell.set(tweet: tweets[indexPath.row])
        cell.inTweetViewController = false
        cell.tweet = tweets[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension TweetsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isLoadingMore) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isLoadingMore = true
                loadingMoreView!.startAnimating()
                
                loadMoreTweet()
            }
        }
    }
}

extension TweetsViewController: TweetCellDelegate {
    func tweetCell(cell: TweetCell) {
        tweets[cell.index].isFavorited = cell.tweet.isFavorited
        tweets[cell.index].favoritesCount = cell.tweet.favoritesCount
        tweets[cell.index].isRetweeted = cell.tweet.isRetweeted
        tweets[cell.index].retweetCount = cell.tweet.retweetCount
        let indexPath = IndexPath(row: cell.index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tweetCell(reply cell: TweetCell) {
        let data = [cell.tweet, cell.index! as AnyObject] as [AnyObject]
        performSegue(withIdentifier: "ReplySegue", sender: data)
    }
}

extension TweetsViewController: NewTweetViewControllerDelegate {
    func newTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
    
    func newTweet(reply: Tweet, index: Int) {
        tweets[index].reply.append(reply)
    }
}

extension TweetsViewController: TweetViewControllerDelegate {
    func tweetViewController(viewController: TweetViewController) {
        tweets[viewController.indexTweet].isFavorited = viewController.tweet.isFavorited
        tweets[viewController.indexTweet].favoritesCount = viewController.tweet.favoritesCount
        tweets[viewController.indexTweet].isRetweeted = viewController.tweet.isRetweeted
        tweets[viewController.indexTweet].retweetCount = viewController.tweet.retweetCount
        let indexPath = IndexPath(row: viewController.indexTweet, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tweetViewController(reply viewController: TweetViewController) {
        tweets[viewController.indexTweet].reply = viewController.tweet.reply
    }
}
