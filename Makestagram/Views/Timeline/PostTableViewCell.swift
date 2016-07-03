//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by JoeB on 7/1/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit
import Bond

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: Post? {
        didSet {
            // 1
            if let post = post {
                //2
                // bind the image of the post to the 'postImage' view
                post.image.bindTo(postImageView.bnd_image)
            }
        }
    }
}