//
//  TweetCell.swift
//  Twitter
//
//  Created by Girge on 10/29/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol TweetCellDelegate {
    func tweetCell(cell: TweetCell)
    
    func tweetCell(reply cell: TweetCell)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var heightConstraintImageContainer: NSLayoutConstraint!
    
    var inTweetViewController: Bool!
    weak var delegate: TweetCellDelegate!
    var index: Int!
    var tweet: Tweet! {
        didSet {
            set()
        }
    }
    
    func set() {
        if let profileImageUrl = tweet.user?.profileImageUrl {
            profileImageView.setImageWith(profileImageUrl, placeholderImage: #imageLiteral(resourceName: "LoadingImage"))
        }
        nameLabel.text = tweet.user?.name
        usernameLabel.text = "@\(tweet.user!.screenname!)"
        
        if inTweetViewController! {
            timeLabel.text = "\(tweet.createdAtString(short: false))"
        } else {
            timeLabel.text = "- \(tweet.createdAtString(short: true))"
        }
        
        contentLabel.text = tweet.text
        
        retweetImageView.image = tweet.isRetweeted ? #imageLiteral(resourceName: "Retweeted") : #imageLiteral(resourceName: "Retweet")
        retweetsCountLabel.text = tweet.retweetCount! > 0 ? "\(tweet.retweetCount!)" : ""
        
        likeImageView.image = tweet.isFavorited ? #imageLiteral(resourceName: "Liked") : #imageLiteral(resourceName: "Like")
        likesCountLabel.text = tweet.favoritesCount! > 0 ? "\(tweet.favoritesCount!)" : ""
        
        heightConstraintImageContainer.constant = 160
        switch tweet.imageUrls.count {
        case 1:
            let imagesView = Bundle.main.loadNibNamed("ImagesView1", owner: self, options: nil)!.first! as! ImagesView1
            imagesView.imageUrl = tweet.imageUrls[0]
            imageContainer.addSubview(imagesView)
            imagesView.snp.makeConstraints({
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.right.equalToSuperview()
            })
            heightConstraintImageContainer.constant = 120
        case 2:
            let imagesView = Bundle.main.loadNibNamed("ImagesView2", owner: self, options: nil)!.first! as! ImagesView2
            imagesView.imageUrls = tweet.imageUrls
            imageContainer.addSubview(imagesView)
            imagesView.snp.makeConstraints({
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.right.equalToSuperview()
            })
        case 3:
            let imagesView = Bundle.main.loadNibNamed("ImagesView3", owner: self, options: nil)!.first! as! ImagesView3
            imagesView.imageUrls = tweet.imageUrls
            imageContainer.addSubview(imagesView)
            imagesView.snp.makeConstraints({
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.right.equalToSuperview()
            })
        case 4:
            let imagesView = Bundle.main.loadNibNamed("ImagesView4", owner: self, options: nil)!.first! as! ImagesView4
            imagesView.imageUrls = tweet.imageUrls
            imageContainer.addSubview(imagesView)
            imagesView.snp.makeConstraints({
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.right.equalToSuperview()
            })
        default:
            imageContainer.subviews.forEach({
                $0.removeFromSuperview()
            })
            heightConstraintImageContainer.constant = 0
        }
    }
    
    func addImagesView() {
        

        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onRetweet(_ sender: UIButton) {
        if !tweet.isRetweeted {
            TwitterClient.shared.retweet(id: tweet.id!, success: { (tweet) in
                print("retweet")
                self.tweet.isRetweeted = tweet.isRetweeted
                self.tweet.retweetCount = tweet.retweetCount
                self.delegate.tweetCell(cell: self)
            })
        } else {
            TwitterClient.shared.unRetweet(id: tweet.id!, success: { (tweet) in
                self.tweet.isRetweeted = false
                self.tweet.retweetCount = tweet.retweetCount! - 1
                self.delegate.tweetCell(cell: self)
            })
        }
    }
    
    @IBAction func onLike(_ sender: UIButton) {
        if tweet.isFavorited {
            TwitterClient.shared.unLikeTweet(id: tweet.id!, success: { (tweet) in
                self.tweet.isFavorited = tweet.isFavorited
                self.tweet.favoritesCount = tweet.favoritesCount
                self.delegate.tweetCell(cell: self)
            })
        } else {
            TwitterClient.shared.likeTweet(id: tweet.id!, success: { (tweet) in
                self.tweet.isFavorited = tweet.isFavorited
                self.tweet.favoritesCount = tweet.favoritesCount
                self.delegate.tweetCell(cell: self)
            })
        }
    }
    @IBAction func onReply(_ sender: UIButton) {
        delegate.tweetCell(reply: self)
    }
}
