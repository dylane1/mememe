//
//  ViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

/*******************************************************************************
CURRENT:
(Oop... Saving to photo library wasn't part of the spec -- now a "feature")

* Future “feature” branches:

• Meme Model
    - Save to nsuserdefaults for now.

• Text field work
    - All caps
    - Choose font
    - Text outline
    - Shrink to fit

• Table view to view previously saved memes
    - Edit?
    - Save to photo library button

• Nav & Toolbar style
    - Pick color scheme
    - Would be nice to show/hide nav & toolbar like photo app


*
*******************************************************************************/

import UIKit
import MobileCoreServices

final class MainViewController: UIViewController {
    typealias ToolbarButtonClosure = () -> Void
    private var cameraButtonClosure: ToolbarButtonClosure?
    private var albumButtonClosure: ToolbarButtonClosure!
    
    private var stateMachine = StateMachine()
    
    private var mainView: MainView!
    private var mainViewViewModel: MainViewViewModel!
    
    private let imagePickerController = UIImagePickerController()
    
    private var navController: NavigationController!
    
    private var errorQueue = [[String]]()
    
  //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedStrings.ViewControllerTitles.memeMe
        
        mainView = view as! MainView
        mainViewViewModel = MainViewViewModel()
        
        configureNavigationItems()
        configureToolbarItems()
        configureImagePicker()
        
        mainView.configure(
            withDataSource: mainViewViewModel,
            albumButtonClosure: albumButtonClosure,
            cameraButtonClosure: cameraButtonClosure,
            stateMachine: stateMachine
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//    }
    
    //MARK: - Public funk(s)

    /** Save Image completion */
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        /** NSError for testing errorQueue */
//        let testErrorUserInfo = [
//            NSLocalizedDescriptionKey : "Operation was unsuccessful."
//        ]
//        let NSTestErrorDomain = "foo"
//        
//        var testError: NSError? = NSError(domain: NSTestErrorDomain, code: 42, userInfo: testErrorUserInfo)
        
        if error == nil {
            /** Reset everything */
            mainViewViewModel.image.value = nil
            mainView.resetTextFields()
        } else {
            magic("error: \(error?.localizedDescription)")
            
            /** 
             Unable to present an error alert because activityVC is already open 
            
             Add error to errorQueue & display after activityVC is dismissed.
            */
            let message     = LocalizedStrings.ErrorAlerts.ImageSaveError.message + error!.localizedDescription
            let errorArray  = [LocalizedStrings.ErrorAlerts.ImageSaveError.title, message]
            errorQueue.insert(errorArray, atIndex: 0)
        }
    }
    
    
    /** Toolbar Actions */
    func cameraButtonTapped() {
        imagePickerController.sourceType = .Camera
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func albumButtonTapped() {
        imagePickerController.sourceType = .PhotoLibrary
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
     
     
    //MARK: - Private funk(s)
    
    private func configureNavigationItems() {
        navController = navigationController as! NavigationController
        
        let shareButtonClosure = { [weak self] in

            let imageToShare = self!.createImage()
            
            /** Save the meme image */
            UIImageWriteToSavedPhotosAlbum(imageToShare, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
            /** Open Activity View Controller */
            let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            
            /** Set completion handler for Share */
            activityVC.completionWithItemsHandler = { [weak self] activityType, completed, returnedItems, activityError in
//                magic("activityType: \(activityType), completed: \(completed), returnedItems: \(returnedItems), activityError: \(activityError)")
                if !completed {
                    var message = LocalizedStrings.ErrorAlerts.ShareError.message
                    
                    if activityError != nil {
                        message += activityError!.localizedDescription
                    } else {
                        message += LocalizedStrings.ErrorAlerts.ShareError.unknownError
                    }
                    let errorArray = [LocalizedStrings.ErrorAlerts.ShareError.title, message]
                    self!.errorQueue.insert(errorArray, atIndex: 0)
                }
                
                self!.checkForErrors()
            }
            self!.presentViewController(activityVC, animated: true, completion: nil)
        }
        
        let cancelButtonClosure = { [weak self] in
            //TODO: Probably should pop a warning alert if an image has been selected & text has been entered
            self!.mainViewViewModel.image.value = nil
            self!.mainView.resetTextFields()
        }
        
        navController.configure(withShareButtonClosure: shareButtonClosure, cancelButtonClosure: cancelButtonClosure, stateMachine: stateMachine)
    }
    
    private func configureToolbarItems() {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            cameraButtonClosure = { [weak self] in
                self!.cameraButtonTapped()
            }
        }
        
        albumButtonClosure = { [weak self] in
            self!.albumButtonTapped()
        }
    }
    
    private func configureImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    private func createImage() -> UIImage {
        /** Hide unedited field before taking snapshot */
        mainView.hidePlaceholderText()
        
        UIGraphicsBeginImageContext(self.view.bounds.size);
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenShot
    }
    
    private func checkForErrors() {
        if errorQueue.count > 0 {
            presentError(withErrorArray: errorQueue.removeLast())
        }
    }
    
    private func presentError(withErrorArray error: [String]) {
        
        let alert = UIAlertController(title: error[0], message: error[1], preferredStyle: .Alert)
       
        alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.ok, style: .Default, handler: { [weak self] (alert: UIAlertAction!) in
            /** There may be more errors in the queue */
            self!.checkForErrors()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        /** Update viewModel so view can update itself */
        mainViewViewModel.image.value = image

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: - UINavigationControllerDelegate
extension MainViewController: UINavigationControllerDelegate {
    /**
    * Need this in order to set self as UIImagePikerController delegate
    * in configureImagePicker()
    */
}





























