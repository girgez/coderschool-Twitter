//
//  ImagesView4.swift
//  Twitter
//
//  Created by Girge on 10/29/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit

class ImagesView4: UIView {
    @IBOutlet var imagesView: [UIImageView]!
    
    var imageUrls: [URL]! {
        didSet{
            for index in 0...3 {
                imagesView[index].setImageWith(imageUrls[index], placeholderImage: #imageLiteral(resourceName: "LoadingImage"))
//                imagesView[index].setImageWith(imageUrls[index])
            }
            addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1 / 1, constant: 0))
        }
    }

    @IBAction func tapImage1(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func tapImage2(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func tapImage3(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func tapImage4(_ sender: UITapGestureRecognizer) {
    }
}
