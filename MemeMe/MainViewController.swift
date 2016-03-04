//
//  ViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//


import UIKit
import MobileCoreServices

final class MainViewController: UIViewController {
    typealias ToolbarButtonClosure = () -> Void
    private var cameraButtonClosure: ToolbarButtonClosure?
    private var albumButtonClosure: ToolbarButtonClosure!
    
    typealias FontButtonClosure = (UIBarButtonItem) -> Void
    private var fontButtonClosure: FontButtonClosure!
    
    /** For keeping track of app state and enabling/disabling navbar buttons */
    private var stateMachine = StateMachine()
    private var navController: NavigationController!
    
    private var mainView: MainView!
    private var mainViewViewModel: MainViewViewModel!
    
    private let imagePickerController = UIImagePickerController()
    
    /** 
     * For keeping track of errors that occur when the imagePickerController is 
     * open, then popping an error alert after imagePickerController has been
     * dismissed
     */
    private var errorQueue = [[String]]()
    
    private var imageToShare: UIImage?
    
    private var memeModel = Meme()
    
    /** Storage */
    private var storedMemesProvider = MemesProvider()
     
     
  //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedStrings.ViewControllerTitles.memeMe
        
        mainView = view as! MainView
        mainViewViewModel = MainViewViewModel()
        
        configureNavigationItems()
        configureToolbarItems()
        configureImagePicker()
        
        let memeTextUpdatedClosure = { [weak self] (updatedMeme: Meme) -> Void in
            self!.memeModel = updatedMeme
        }
        
        let memeImageUpdatedClosure = { [weak self] (originalMeme: Meme, newImage: UIImage?) -> Meme in
            /** Delete previous image from storage if needed (MemeMe v2)*/
            
            
            /** Update meme model */
            self!.memeModel.image = newImage
            
            return self!.memeModel
        }
        
        mainView.configure(
            withDataSource: mainViewViewModel,
            albumButtonClosure: albumButtonClosure,
            cameraButtonClosure: cameraButtonClosure,
            fontButtonClosure: fontButtonClosure,
            memeTextUpdatedClosure: memeTextUpdatedClosure,
            memeImageUpdatedClosure: memeImageUpdatedClosure,
            stateMachine: stateMachine
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Internal funk(s)

    /** Save Image completion */
    /*******************************************************************************
    * Not currently saving to the Photo Album, but will be an option in MemeMe v2
    *
    *******************************************************************************/
//    internal func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        /** NSError for testing errorQueue */
//        let testErrorUserInfo = [
//            NSLocalizedDescriptionKey : "Operation was unsuccessful."
//        ]
//        let NSTestErrorDomain = "foo"
//        
//        var testError: NSError? = NSError(domain: NSTestErrorDomain, code: 42, userInfo: testErrorUserInfo)
        
//        if error == nil {
//            /** Reset everything */
//            mainViewViewModel.image.value = nil
//            mainView.resetTextFields()
//        } else {
//            magic("error: \(error?.localizedDescription)")
//            
//            /** 
//             Unable to present an error alert because activityVC is already open 
//            
//             Add error to errorQueue & display after activityVC is dismissed.
//            */
//            let message     = LocalizedStrings.ErrorAlerts.ImageSaveError.message + error!.localizedDescription
//            let errorArray  = [LocalizedStrings.ErrorAlerts.ImageSaveError.title, message]
//            errorQueue.insert(errorArray, atIndex: 0)
//        }
//    }
    
    
    /** Toolbar Actions */
    internal func cameraButtonTapped() {
        imagePickerController.sourceType = .Camera
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    internal func albumButtonTapped() {
        imagePickerController.sourceType = .PhotoLibrary
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    internal func fontButtonTapped(button: UIBarButtonItem) {
        /** Present a popover with available fonts */
        let storyboard = UIStoryboard(name: Constants.StoryBoardIDs.main, bundle: nil)
        
        let fontListTableVC = storyboard.instantiateViewControllerWithIdentifier(Constants.StoryBoardIDs.fontListTableVC) as! FontListTableViewController
        fontListTableVC.preferredContentSize = CGSizeMake(250, 300)
        fontListTableVC.configure(withViewModel: mainViewViewModel)
        fontListTableVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        let popoverController = fontListTableVC.popoverPresentationController!
        popoverController.barButtonItem = button
        popoverController.permittedArrowDirections = .Any
        popoverController.delegate = self
        
        presentViewController(fontListTableVC, animated: true, completion: nil)
    }
     
     
    //MARK: - Private funk(s)
    
    private func configureNavigationItems() {
        navController = navigationController as! NavigationController
        
        let shareButtonClosure = { [weak self] in

            self!.imageToShare = self!.createImage()
            
            /** Save the meme image to photos album */
//            UIImageWriteToSavedPhotosAlbum(self!.imageToShare!, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
            /** Open Activity View Controller */

            guard let image = self!.imageToShare as UIImage! else  { fatalError("error creating image") }
            
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                
            /** Set completion handler for Share */
            activityVC.completionWithItemsHandler = { [weak self] activityType, completed, returnedItems, activityError in
                if !completed {
                    var message = LocalizedStrings.ErrorAlerts.ShareError.message
                    
                    if activityError != nil {
                        message += activityError!.localizedDescription
                    } else {
                        message += LocalizedStrings.ErrorAlerts.ShareError.unknownError
                    }
                    let errorArray = [LocalizedStrings.ErrorAlerts.ShareError.title, message]
                    self!.errorQueue.insert(errorArray, atIndex: 0)
                } else {
                    /** Success! */
                    
                    
                    /** Save the meme to storage */
                    self!.memeModel.memedImage = image
                    self!.storedMemesProvider.addNewMemeToStorage(self!.memeModel)

                    /** Reset everything */
                    self!.memeModel = Meme()
                    self!.mainViewViewModel.image.value = nil
                    self!.mainView.resetTextFields()
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
        
        navController.configure(
            withShareButtonClosure: shareButtonClosure,
            cancelButtonClosure: cancelButtonClosure,
            stateMachine: stateMachine)
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
        
        fontButtonClosure = { [weak self] (button: UIBarButtonItem) in
            self!.fontButtonTapped(button)
        }
    }
    
    private func configureImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    private func createImage() -> UIImage {
        /** Hide unedited field before taking snapshot */
        mainView.hidePlaceholderText()
        
        let info = mainView.getInfoForImageContext()
        
        /** Correct for height of navigationBar */
        var correctedY = info.y + CGFloat(navController.navigationBar.frame.size.height)
        
        /** 
         * If portrait, also correct for status bar
         *
         * Note: using !isLandscape because isPortrait is nil if the device
         * hasn't been rotated yet.
         */
        if !UIDevice.currentDevice().orientation.isLandscape.boolValue {
            correctedY += UIApplication.sharedApplication().statusBarFrame.size.height
        }

        UIGraphicsBeginImageContextWithOptions(info.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(context, -info.x, -correctedY)
        view.layer.renderInContext(context)
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
    
//    private func listFonts() {
//        for family: String in UIFont.familyNames() {
//            print("\(family)")
//            for names: String in UIFont.fontNamesForFamilyName(family) {
//                print("   \(names)")
//            }
//        }
//    }
}

//MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate {
    internal func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        /** Update viewModel so view can update itself */
        mainViewViewModel.image.value = image
        
        /** Set the image in the memeModel so it can be saved to storage */
        memeModel.image = image
        magic("updated memeModel (with image) \(memeModel)")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(picker: UIImagePickerController) {
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

enum DestinationOrientation {
    case Landscape, Portrait
}
extension MainViewController {
    /** Tell view to update constraints on text fields upon rotation */    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        let newOrientation: DestinationOrientation = (size.width > size.height) ? .Landscape : .Portrait

        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) in
                self.mainView.updateTextFieldContstraints(withNewOrientation: newOrientation)
                self.mainView.setNeedsLayout()
            }, completion: nil)
    }
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    /**
     * Needed to show the font list in popover in compact
     * environments (phone), otherwise it's a full screen modal
     */
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
