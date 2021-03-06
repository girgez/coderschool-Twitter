//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Girge on 10/31/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    func newTweet(tweet: Tweet)
    func newTweet(reply: Tweet, index: Int)
}

class NewTweetViewController: UIViewController {
    let limitCharacter = 140
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var replyTitleContainer: UIView!
    @IBOutlet weak var replyTitle: UILabel!
    
    weak var delegate: NewTweetViewControllerDelegate!
    var tweet: Tweet?
    var index: Int?
    var characterCount = 140 {
        didSet{
            characterCountLabel.text = "\(characterCount)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let avatarUrl = User.shared?.profileImageUrl {
            avatarView.setImageWith(avatarUrl)
        }
        
        if let tweet = tweet {
            navigationItem.title = "Reply"
            tweetButton.setTitle("Reply", for: .disabled)
            tweetButton.setTitle("Reply", for: .normal)
            replyTitle.text = "Reply to \(tweet.user!.name!)"
            replyTitleContainer.isHidden = false
            textView.text = "@\(tweet.user!.screenname!) "
        }
        
        // noti keyboard
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    func adjustInsetForKeyboardShow(notification: NSNotification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        bottomConstraint.constant = keyboardFrame.height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
    }
    
    func keyboardWillShow(notification: NSNotification) {
        adjustInsetForKeyboardShow(notification: notification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTweetButton(_ sender: UIButton) {
        textView.resignFirstResponder()
        ProgressHUD.show()
        if let tweet = tweet {
            TwitterClient.shared.newTweet(text: textView.text, replyId: tweet.replyId ?? tweet.id, success: { (tweet) in
//                tweet.text = self.textView.text
                self.delegate.newTweet(reply: tweet, index: self.index!)
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                }, failure: {(error) -> Void in
                    ProgressHUD.dismiss()
            })
        } else {
            TwitterClient.shared.newTweet(text: textView.text, replyId: nil, success: { (tweet) in
                self.delegate.newTweet(tweet: tweet)
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                }, failure: {(error) -> Void in
                    ProgressHUD.dismiss()
            })
        }
        
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}

extension NewTweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        characterCount = limitCharacter - textView.text.characters.count
        if characterCount == limitCharacter || characterCount < 0 {
            tweetButton.isEnabled = false
            characterCountLabel.textColor = #colorLiteral(red: 0.937254902, green: 0.3436582104, blue: 0.1739018287, alpha: 1)
        } else {
            tweetButton.isEnabled = true
            characterCountLabel.textColor = #colorLiteral(red: 0.368627451, green: 0.6274509804, blue: 0.937254902, alpha: 1)
        }
    }
}
