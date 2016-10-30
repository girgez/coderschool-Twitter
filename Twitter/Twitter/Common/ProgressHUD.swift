//
//  ProgressHUD.swift
//  Twitter
//
//  Created by Girge on 10/31/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProgressHUD {
    class func setup() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    class func show() {
        SVProgressHUD.show()
    }
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
}
