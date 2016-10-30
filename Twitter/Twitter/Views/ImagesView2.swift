//
//  ImagesView2.swift
//  Twitter
//
//  Created by Girge on 10/29/16.
//  Copyright © 2016 Girgez. All rights reserved.
//

import UIKit

class ImagesView2: UIView {
    @IBOutlet var imagesView: [UIImageView]!

    var imageUrls: [URL]! {
        didSet{
            for index in 0...1 {
                imagesView[index].setImageWith(imageUrls[index], placeholderImage: #imageLiteral(resourceName: "LoadingImage"))
//                imagesView[index].setImageWith(imageUrls[index])
            }
        }
    }
    @IBAction func tapImage1(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func tapImage2(_ sender: UITapGestureRecognizer) {
    }
}
