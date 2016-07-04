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
    
    // Following Relation
    static let ParseFollowClass = "Follow"
    static let ParseFollowFromUser = "fromUser"
    static let ParseFollowToUser = "toUser"
    
    // Like Relation
    static let ParseLikeClass = "Like"
    static let ParseLikeToPost = "toPost"
    static let ParseLikeFromUser = "fromUser"
    
    // Post Relation
    static let ParsePostUser = "user"
    static let ParsePostCreatedAt = "createdAt"
    
    // Flagged Content Relation
    static let ParseFlaggedContentClass = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost = "toPost"
    
    // User Relation
    static let ParseUserUsername      = "username"
    
    static func timeLineRequestForCurrentUser(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        
        
        //Create a qurey that gets the follows of a current user
        let followingQuery = PFQuery(className: ParseFollowClass)
        followingQuery.whereKey(ParseFollowFromUser, equalTo:PFUser.currentUser()!)
        
        //Get posts from users that the current user is following
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
        
        //Get all posts that the current user has uploaded
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        //The combined query should get the PFUser that is tied to each post
        query.includeKey(ParsePostUser)
        //This orders posts in chronological order
        query.orderByDescending(ParsePostCreatedAt)
        
        // defines how many of our items should be skipped (our startIndex)
        query.skip = range.startIndex
        
        // limit defines how many we want to load (end index - start)
        query.limit = range.endIndex - range.startIndex

        
        //Start the network request to actually fetch the items int he query
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //function for liking posts
    static func likePost(user: PFUser, post: Post) {
        //create a new like
        let likeObject = PFObject(className: ParseLikeClass)
        //define user and post
        likeObject[ParseLikeFromUser] = user
        likeObject[ParseLikeToPost] = post
        
        //save it
        likeObject.saveInBackgroundWithBlock(nil)
    }
    
    //deleting likes
    static func unlikePost(user: PFUser, post: Post) {
        // find the like of a given user that belongs to the post
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeFromUser, equalTo: user)
        query.whereKey(ParseLikeToPost, equalTo: post)
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            // iterate over the matching objects and delete them
            if let results = results {
                for like in results {
                    like.deleteInBackgroundWithBlock(nil)
                }
            }
        }
    }
    
    // get all the likes for a given post
    //take a query result block as an argument
    static func likesForPost(post: Post, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeToPost, equalTo: post)
        // fetch all the users who liked the post
        query.includeKey(ParseLikeFromUser)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}
