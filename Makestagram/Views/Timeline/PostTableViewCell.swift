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
import Parse

class PostTableViewCell: UITableViewCell {
    //declares all the parts of the cell
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
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
    
    @IBAction func moreButtonTapped(sender: UIButton) {
    }
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    
}