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
    
    var posts: [Post] = []
    
    var photoTakingHelper = PhotoTakingHelper?()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Here we set the current view controller to be a delegate of the tab bar controller
        self.tabBarController?.delegate = self
    }
    
    //Loads the querys for the timeline
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Start the network request to actually fetch the items int he query
        ParseHelper.timeLineRequestForCurrentUser{(result: [PFObject]?, error: NSError?) -> Void in
            
            //here we recieve all posts that meet the rerequirement
            self.posts = result as? [Post] ?? []
            
            //here we reload the data of the tableview
            self.tableView.reloadData()
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this function is where we get the photo
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            let post = Post()
            // store the image using the new obervable way
            post.image.value = image!
            post.uploadPost()
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

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // give the tableview as many rows as we have posts
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        // return a cell with type PostTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        let post = posts[indexPath.row]
        
        //right before a post is displayed, download it
        post.downloadImage()
        
        //get the likes for a post
        post.fetchLikes()
        
        //assign the downloaded post to the cell's post property
        cell.post = post
        
        return cell
    }
}








