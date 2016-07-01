//
//  Post.swift
//  Makestagram
//
//  Created by JoeB on 6/30/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

//create a custom object and inherit PFObject
class Post: PFObject, PFSubclassing {
    var image: UIImage!
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
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
        if let image = image {
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
}
