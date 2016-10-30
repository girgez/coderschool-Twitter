//
//  ImagesView1.swift
//  Twitter
//
//  Created by Girge on 10/29/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit
import SnapKit

class ImagesView1: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageRatioConstraint: NSLayoutConstraint!
    
    var imageUrl: URL! {
        didSet{
            imageView.setImageWith(imageUrl, placeholderImage: #imageLiteral(resourceName: "LoadingImage"))
//            imageView.setImageWith(imageUrl)
        }
    }
    
    var imageRatio: [CGFloat]! {
        didSet{
            imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: imageView, attribute: NSLayoutAttribute.width, multiplier: imageRatio[1] / imageRatio[0], constant: 0))
        }
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
    }
}
