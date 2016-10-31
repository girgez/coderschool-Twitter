//
//  Common.swift
//  Twitter
//
//  Created by Girge on 10/31/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import Foundation
import UIKit

class Common {
    class func setRootView(vcIdentifier: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vcIdentifier)
        appDelegate.window?.rootViewController = nextVC
    }
}
