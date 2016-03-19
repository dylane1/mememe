//
//  ViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//


import UIKit
import MobileCoreServices

final class MemeEditorViewController: UIViewController {
    private var mainView: MemeEditorView!
    private var mainViewViewModel: MemeEditorViewModel!
    private var navController: MemeEditorNavigationController!
    
    /** Toolbar button closures (passed to mainView & its toolbar */
    private var cameraButtonClosure: BarButtonClosure?
    private var albumButtonClosure: BarButtonClosure!
    private var fontButtonClosure: BarButtonClosureReturningButtonSource!
    private var fontColorButtonClosure: BarButtonClosureReturningButtonSource!
    
    /** For keeping track of app state and enabling/disabling navbar buttons */
    private var stateMachine = MemeEditorStateMachine()
    
    //FIXME: Set to optional & nil it after closing image picker
    private let imagePickerController = UIImagePickerController()
    
    /** 
     * For keeping track of errors that occur when the imagePickerController is 
     * open, then popping an error alert after imagePickerController has been
     * dismissed
     */
     //TODO: Remove errorQueue (not saving image to photo library)
    private var errorQueue = [[String]]()
    
    
    
    
    
    //TODO: ActivityViewControllerPresentable
    private var imageToShare: UIImage?
    
    private var memeModel = Meme()
    
    /** Storage */
    private var storedMemesProvider = MemesProvider()
     
     
    //MARK: - View Lifecycle
    
    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        magic("\(self.description) is loaded   ---------------->")
        
        title = LocalizedStrings.ViewControllerTitles.memeMe
        
        mainView = view as! MemeEditorView
        mainViewViewModel = MemeEditorViewModel()
        
        getFontFromDefaults()
        
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
            fontColorButtonClosure: fontColorButtonClosure,
            memeTextUpdatedClosure: memeTextUpdatedClosure,
            memeImageUpdatedClosure: memeImageUpdatedClosure,
            stateMachine: stateMachine
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    //MARK: - Configuration
    
    internal func configure(withMeme meme: Meme?) {
        
    }
    
    
    
    private func getFontFromDefaults() {
        if let fontName = Constants.userDefaults.stringForKey(Constants.StorageKeys.fontName) as String! {
            var i = 0
            for name in Constants.FontFamilyNameArray {
                if name == fontName {
                    mainViewViewModel.font.value = Constants.FontArray[i]
                }
                i++
            }
        } else {
            /** Default font */
            mainViewViewModel.font.value =  Constants.Fonts.impact
        }
        
        if let fontColor = Constants.userDefaults.stringForKey(Constants.StorageKeys.fontColor) as String! {
            var i = 0
            for color in Constants.FontColorStringArray {
                if color == fontColor {
                    mainViewViewModel.fontColor.value = Constants.FontColorArray[i]
                }
                i++
            }
        } else {
            /** Default color */
            mainViewViewModel.fontColor.value =  Constants.ColorScheme.white
        }
    }
    
    private func configureNavigationItems() {
        navController = navigationController as! MemeEditorNavigationController
        
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
                    var message = LocalizedStrings.Alerts.ShareError.message
                    
                    if activityError != nil {
                        message += activityError!.localizedDescription
                    } else {
                        message += LocalizedStrings.Alerts.ShareError.unknownError
                    }
                    let errorArray = [LocalizedStrings.Alerts.ShareError.title, message]
                    self!.errorQueue.insert(errorArray, atIndex: 0)
                    
                    /** Show unedited field if hidden */
                    self!.mainView.showPlaceholderText()
                } else {
                    /** Success! */
                    
                    
                    /** Save the meme to storage */
                    self!.memeModel.memedImage = image
                    self!.storedMemesProvider.addNewMemeToStorage(self!.memeModel, completion: nil)

                    /** Reset everything */
                    self!.memeModel = Meme()
                    self!.mainViewViewModel.image.value = nil
                    self!.mainView.resetTextFields()
                }
                
                self!.checkForErrors()
            }

            self!.presentViewController(activityVC, animated: true, completion: nil)
        }
        
        let saveButtonClosure = { [weak self] in
            guard let image = self!.createImage() as UIImage! else  { fatalError("error creating image") }
            /** Save the meme to storage */
            self!.memeModel.memedImage = image
            self!.storedMemesProvider.addNewMemeToStorage(self!.memeModel) {
                //TODO: Alert?
                
                /** close meme editor */
                self!.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        let clearButtonClosure = { [weak self] in
            //TODO: Probably should pop a warning alert if an image has been selected & text has been entered
            self!.mainViewViewModel.image.value = nil
            self!.mainView.resetTextFields()
        }
        
        navController.configure(
            withShareButtonClosure: shareButtonClosure,
            saveButtonClosure: saveButtonClosure,
            clearButtonClosure: clearButtonClosure,
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
        
        fontColorButtonClosure = { [weak self] (button: UIBarButtonItem) in
            self!.fontColorButtonTapped(button)
        }
    }
    
    private func configureImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    
    //MARK: - Actions
    
    /** Toolbar Actions */
    private func cameraButtonTapped() {
        imagePickerController.sourceType = .Camera
        presentImagePicker()
    }
    
    private func albumButtonTapped() {
        imagePickerController.sourceType = .PhotoLibrary
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        if presentedViewController == nil {
            presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            dismissViewControllerAnimated(true) {
                self.presentViewController(self.imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    private func fontButtonTapped(button: UIBarButtonItem) {
        /** Present a popover with available fonts */
        let storyboard = UIStoryboard(name: Constants.StoryBoardIDs.main, bundle: nil)
        
        let fontListTableVC = storyboard.instantiateViewControllerWithIdentifier(Constants.StoryBoardIDs.fontListTableVC) as! FontListTableViewController
        fontListTableVC.preferredContentSize = CGSizeMake(250, 300)
        fontListTableVC.configure(withViewModel: mainViewViewModel)
        fontListTableVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        presentPopover(withViewController: fontListTableVC, fromButton: button)
    }
    
    private func fontColorButtonTapped(button: UIBarButtonItem) {
        /** Present a popover with available font colors */
        let storyboard = UIStoryboard(name: Constants.StoryBoardIDs.main, bundle: nil)
        
        let fontColorsVC = storyboard.instantiateViewControllerWithIdentifier(Constants.StoryBoardIDs.fontColorSelectionVC) as! FontColorSelectionViewController
        fontColorsVC.preferredContentSize = CGSizeMake(260, 116)
        fontColorsVC.configure(withViewModel: mainViewViewModel)
        fontColorsVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        presentPopover(withViewController: fontColorsVC, fromButton: button)
    }
    
    private func presentPopover(withViewController vc: UIViewController, fromButton button: UIBarButtonItem) {
        let popoverController = vc.popoverPresentationController!
        popoverController.barButtonItem = button
        popoverController.permittedArrowDirections = .Any
        popoverController.delegate = self
        
        if presentedViewController == nil {
            presentViewController(vc, animated: true, completion: nil)
        } else {
            dismissViewControllerAnimated(true) {
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
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
}

//MARK: - UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    internal func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        /** Update viewModel so view can update itself */
        mainViewViewModel.image.value = image
        
        /** Set the image in the memeModel so it can be saved to storage */
        memeModel.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: - UINavigationControllerDelegate
extension MemeEditorViewController: UINavigationControllerDelegate {
    /**
    * Need this in order to set self as UIImagePikerController delegate
    * in configureImagePicker()
    */
}

enum DestinationOrientation {
    case Landscape, Portrait
}

//MARK: - UIContentContainer
extension MemeEditorViewController {
    /** Tell view to update constraints on text fields upon rotation */    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        let newOrientation: DestinationOrientation = (size.width > size.height) ? .Landscape : .Portrait

        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) in
                self.mainView.updateTextFieldContstraints(withNewOrientation: newOrientation)
                self.mainView.setNeedsLayout()
            }, completion: nil)
    }
}

extension MemeEditorViewController: UIPopoverPresentationControllerDelegate {
    /**
     * Needed to show the font list in popover in compact
     * environments (phone), otherwise it's a full screen modal
     */
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

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



