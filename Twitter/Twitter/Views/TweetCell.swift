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
//    func tweetCell(cell: TweetCell, updateData: [String: AnyObject])
    func tweetCell(cell: TweetCell)
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
        timeLabel.text = "- \(tweet.createdAtString!)"
        contentLabel.text = tweet.text
        
        retweetImageView.image = tweet.isRetweeted ? #imageLiteral(resourceName: "Retweeted") : #imageLiteral(resourceName: "Retweet")
        retweetsCountLabel.text = tweet.retweetCount! > 0 ? "\(tweet.retweetCount!)" : ""
        
        likeImageView.image = tweet.isFavorited ? #imageLiteral(resourceName: "Liked") : #imageLiteral(resourceName: "Like")
        likesCountLabel.text = tweet.favoritesCount! > 0 ? "\(tweet.favoritesCount!)" : ""
        
        imageContainer.snp.remakeConstraints({
            $0.height.greaterThanOrEqualTo(0)
        })
        switch tweet.imageUrls.count {
        case 1:
            let imagesView = Bundle.main.loadNibNamed("ImagesView1", owner: self, options: nil)!.first! as! ImagesView1
            imagesView.imageUrl = tweet.imageUrls[0]
            imagesView.imageRatio = tweet.imageRatio
            imageContainer.addSubview(imagesView)
            imagesView.snp.makeConstraints({
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.right.equalToSuperview()
            })
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
//            imageContainer.frame.size = CGSize(width: imageContainer.frame.width, height: 0)
            imageContainer.subviews.forEach({
                $0.removeFromSuperview()
            })
            imageContainer.snp.remakeConstraints({
                $0.height.equalTo(0)
            })
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
        print("retweet")
        if tweet.isRetweeted {
            TwitterClient.shared.retweet(id: tweet.id!, success: { (tweet) in
                
            })
        } else {
            TwitterClient.shared.unRetweet(id: tweet.id!, success: { (tweet) in
                
            })
        }
    }
    
    @IBAction func onLike(_ sender: UIButton) {
        if tweet.isFavorited {
            TwitterClient.shared.unLikeTweet(id: tweet.id!, success: { (tweet) in
                self.tweet.isFavorited = tweet.isFavorited
                self.tweet.favoritesCount = tweet.favoritesCount
                self.likeImageView.image = tweet.isFavorited ? #imageLiteral(resourceName: "Liked") : #imageLiteral(resourceName: "Like")
                self.likesCountLabel.text = tweet.favoritesCount! > 0 ? "\(tweet.favoritesCount!)" : ""
                self.delegate.tweetCell(cell: self)
            })
        } else {
            TwitterClient.shared.likeTweet(id: tweet.id!, success: { (tweet) in
                self.tweet.isFavorited = tweet.isFavorited
                self.tweet.favoritesCount = tweet.favoritesCount
                self.likeImageView.image = tweet.isFavorited ? #imageLiteral(resourceName: "Liked") : #imageLiteral(resourceName: "Like")
                self.likesCountLabel.text = tweet.favoritesCount! > 0 ? "\(tweet.favoritesCount!)" : ""
                self.delegate.tweetCell(cell: self)
            })
        }
    }
}
