//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by JoeB on 6/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse


class TimelineViewController: UIViewController {
    
    var photoTakingHelper = PhotoTakingHelper?()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Here we set the current view controller to be a delegate of the tab bar controller
        self.tabBarController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this function is where we get the photo
    func takePhoto() {
        //at the init of this object it will go through the whole image selector shpeil
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            if let image = image {
                //create an image file object with the image we selected as the data
                let imageData = UIImageJPEGRepresentation(image, 0.8)!
                let imageFile = PFFile(name: "image.jpg", data: imageData)!
                
                //create a new post that will go to the server with the image file
                let post = PFObject(className: "Post")
                post["imageFile"] = imageFile
                
                //save the file to the server
                post.saveInBackground()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//This modifies the behavior of the tab bar
//we return a boolean value, if the value is true, we will not display the normal view controller, false will
//generally just behave differently if we want PhotoViewController
extension TimelineViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
    }
}
