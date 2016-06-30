//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by JoeB on 6/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

//defines the signature that any callbacks of our class (PhotoTakingHelper) need
typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    
    // this serves the purpose of allowing us to create views
    weak var viewController: UIViewController!
    
    //this will store the callback function
    var callback: PhotoTakingHelperCallback
    
    //this will alow us to capture images
    var imagePickerController: UIImagePickerController?
    
    //we call show source selection at init
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        //here
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection(){
        //Creates the popup alert for photos and adds the options (actions)
        let alertController = UIAlertController(title: nil, message: "Where do you want yout picture from", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        let photoLibraryAction = UIAlertAction(title: "Photo From Library", style: .Default) { (action) in
            //nothing yet
        }
        
        alertController.addAction(photoLibraryAction)
        
        //show camera popup if it is AVAILABLE
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from camera", style: .Default) { (action) in
                // nothing yet
            }
            
            alertController.addAction(cameraAction)
        }
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
