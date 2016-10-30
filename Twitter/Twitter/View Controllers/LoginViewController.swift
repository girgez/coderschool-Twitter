//
//  LoginViewController.swift
//  Twitter
//
//  Created by Girge on 10/28/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingProgress: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingProgress.isHidden = true
        loginButton.layer.cornerRadius = 5
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        loadingProgress.isHidden = false
        loginButton.isEnabled = false
        TwitterClient.shared.login(success: {
            TwitterClient.shared.currentAccount(success: { (user) in
                User.shared = user
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                })
        }, failure: { (error) in
            print(error.localizedDescription)
            self.loadingProgress.isHidden = true
            self.loginButton.isEnabled = true
        })
    }
}
