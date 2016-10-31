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
    
    var imageUrl: URL! {
        didSet{
            imageView.setImageWith(imageUrl, placeholderImage: #imageLiteral(resourceName: "LoadingImage"))
//            imageView.setImageWith(imageUrl)
        }
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
    }
}
