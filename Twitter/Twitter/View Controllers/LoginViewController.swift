//
//  LoginViewController.swift
//  Twitter
//
//  Created by Girge on 10/28/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit
import  BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        TwitterClient.shared?.login(success: { 
            print("logged in")
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
}
