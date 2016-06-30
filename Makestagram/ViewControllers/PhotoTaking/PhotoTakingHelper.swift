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
    
    //Creates the popup alert for photos and adds the options (actions), then displays the popup
    func showPhotoSourceSelection(){
        
        //create the popup
        let alertController = UIAlertController(title: nil, message: "Where do you want yout picture from", preferredStyle: .ActionSheet)
        
        //create and add cancel cation
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        //create and add library action
        let photoLibraryAction = UIAlertAction(title: "Photo From Library", style: .Default) { (action) in
            //once selected show the gallery via callback
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        //show (also create and stuff) camera popup if it is AVAILABLE
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from camera", style: .Default) { (action) in
                // once selected, show the camera via callback
                self.showImagePickerController(.Camera)
            }
            
            alertController.addAction(cameraAction)
        }
        
        //display the popup
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //this function shows the image picker views (the camera and the gallery)
    //It is responsible for actually getting the photos
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType){
        //create the image picker
        imagePickerController = UIImagePickerController()
        
        //set the source type
        imagePickerController!.sourceType = sourceType
        
        //creates a delegate
        imagePickerController!.delegate = self
        
        //display the image picker
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
        
    }
    
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //when we are done selecting an image, dismiss the controller and return the image we selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        callback(image)
    }
    
    //when we cancel out of the controller, hide it
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

