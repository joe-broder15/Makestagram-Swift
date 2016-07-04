//
//  Post.swift
//  Makestagram
//
//  Created by JoeB on 6/30/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse
import Bond

//create a custom object and inherit PFObject
class Post: PFObject, PFSubclassing {
    var image: Observable<UIImage?> = Observable(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    var likes: Observable<[PFUser]?> = Observable(nil)
    
    //this declares the propertes
    //@NSManages means do not handle it in the initializer beacuse parse will handle it
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    //create a connection between your class and the parse class
    static func parseClassName() -> String {
        return "post"
    }
    
    //this is boilerplate code for parse
    override init() {
        super.init()
    }
    
    //this too ^^^
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            //inform parse about the subclass
            self.registerSubclass()
        }
    }
    
    func uploadPost(){
        if let image = image.value {
            //we return if either of the values are nil
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            
            //posts are associated with current user
            user = PFUser.currentUser()
            self.imageFile = imageFile
            
            //Create upload task and store the ID in the photoUploadTask property
            photoUploadTask =  UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            //save the post and image file by calling saveInBackgroundWithBlock
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                
                //when the task is complete we immediately end it
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
    
    func downloadImage() {
        // if image is not downloaded yet, get it
        // is image.value already stored
        if (image.value == nil) {
            // stard the download in the background
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    // wnen download is complete ubdate image.value
                    self.image.value = image
                }
            }
        }
    }
    
    
    func fetchLikes() {
        // if we already have a stored like value, return nill
        if (likes.value != nil) {
            return
        }
        
        // fetch the likes for the current post using likesForPost
        ParseHelper.likesForPost(self, completionBlock: { (likes: [PFObject]?, error: NSError?) -> Void in
            // filter returns only items from the original array that meet the requirements in the closure
            //filter our likes from users that no longer exist
            let validLikes = likes?.filter { like in like[ParseHelper.ParseLikeFromUser] != nil }
            
            // map does the same thing as filter, but replaces instead of deletes
            //we now replace all the likes in the array with the users who gave the like
            self.likes.value = validLikes?.map { like in
                let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser
                
                return fromUser
            }
        })
    }
    
    //checks to see if the user has liked a post
    //takes one argument and returns a bool
    func doesUserLikePost(user: PFUser) -> Bool {
        //unwrap the potional likes.value
        if let likes = likes.value {
            //if the likes array contains the user, return so and vice versa
            return likes.contains(user)
        } else {
            return false
        }
    }
    
    //handles toggling post likes
    //takes one argument a user
    func toggleLikePost(user: PFUser) {
        if (doesUserLikePost(user)) {
            // if post is liked, unlike it now
            // take the current user out of the like array
            likes.value = likes.value?.filter { $0 != user }
            ParseHelper.unlikePost(user, post: self)
        } else {
            // if this post is not liked yet, like it now
            //append the user to the likes array
            likes.value?.append(user)
            ParseHelper.likePost(user, post: self)
        }
    }
        

}
