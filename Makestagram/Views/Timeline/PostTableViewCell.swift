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
    
    var postDisposable: DisposableType?
    var likeDisposable: DisposableType?
    
    // Generates a comma separated list of usernames from an array (e.g. "User1, User2")
    func stringFromUserList(userList: [PFUser]) -> String {
        // get the usernames of all the users
        let usernameList = userList.map { user in user.username! }
        // separate the array with commas
        let commaSeparatedUserList = usernameList.joinWithSeparator(", ")
        //return it
        return commaSeparatedUserList
    }
    
    var post: Post? {
        didSet {
            // destroy old bindings
            postDisposable?.dispose()
            likeDisposable?.dispose()
            
            if let post = post {
                // create the new binding for images and likes
                postDisposable = post.image.bindTo(postImageView.bnd_image)
                //use observe to call code whenever likes is updated
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                    // unwrap the optional array value
                    if let value = value {
                        // Update the likes label
                        self.likesLabel.text = self.stringFromUserList(value)
                        // change the state of the like button
                        self.likeButton.selected = value.contains(PFUser.currentUser()!)
                        // if nobody likes the post, hide the icon
                        self.likesIconImageView.hidden = (value.count == 0)
                    } else {
                        // if nothing, set all elements to default values
                        self.likesLabel.text = ""
                        self.likeButton.selected = false
                        self.likesIconImageView.hidden = true
                    }
                }
            }
        }
    }
    
    @IBAction func moreButtonTapped(sender: UIButton) {
    }
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    
}

//this does stuff for the like button
extension PFObject {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
    
}