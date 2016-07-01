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
        
        //Create a qurey that gets the follows of a current user
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        
        //Get posts from users that the current user is following
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        //Get all posts that the current user has uploaded
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        //Create a combined query of both user and follow posts (orQueryWithSubQueries)
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        
        //The combined query should get the PFUser that is tied to each post
        query.includeKey("user")
        
        //This orders posts in chronological order
        query.orderByAscending("createdAt")
        
        //Start the network request to actually fetch the items int he query
        query.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError? ) -> Void in
            
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
        //at the init of this object it will go through the whole image selector shpeil
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
        let post = Post()
        post.image = image
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
        
        // return a placeholder cell with text "post"
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell")!
        
        cell.textLabel!.text = "Post"
        
        return cell
    }
}








