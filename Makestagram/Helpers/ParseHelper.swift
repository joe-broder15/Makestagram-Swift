//
//  ParseHelper.swift
//  Makestagram
//
//  Created by JoeB on 7/1/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    static func timeLineRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        
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
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}
