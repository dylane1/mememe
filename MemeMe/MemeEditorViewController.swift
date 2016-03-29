//
//  ViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//


import UIKit
import MobileCoreServices

final class MemeEditorViewController: UIViewController, ActivityViewControllerPresentable {
    //TODO: make private & passed in configure
    /** Passed by presenting view controller */
    var vcShouldBeDismissed: BarButtonClosure!
    
    private var meme = Meme()
    
    
    /** View */
    private var mainView: MemeEditorView!
    private var mainViewViewModel: MemeEditorViewModel!
    
    /** Navigation */
//    private var navController: MemeEditorNavigationController!
    @IBOutlet weak var navItem: MemeEditorNavigationItem!
    
    /** For keeping track of app state and enabling/disabling navbar buttons */
    private var stateMachine = MemeEditorStateMachine()
    
    /** Toolbar button closures (passed to mainView & its toolbar) */
    private var cameraButtonClosure: BarButtonClosure?
    private var albumButtonClosure: BarButtonClosure!
    private var fontButtonClosure: BarButtonClosureReturningButtonSource!
    private var fontColorButtonClosure: BarButtonClosureReturningButtonSource!
    
    /** Picking an image */
    private lazy var imagePickerController = UIImagePickerController()
    
    /** ActivityViewControllerPresentable -- For Sharing */
    internal var activityViewController: UIActivityViewController?
    internal var activitySuccessCompletion: (() -> Void)? = nil
    
    /** Saving to storage & editing */
    private lazy var storedMemesProvider = MemesProvider()
    private var storedIndex: Int?
    private var memeToUpdate: Meme?
    
    /** 
     * For keeping track of errors that occur when the imagePickerController is 
     * open, then popping an error alert after imagePickerController has been
     * dismissed
     */
     //TODO: Remove errorQueue (not saving image to photo library)
    private var errorQueue = [[String]]()
    
    
    //MARK: - View Lifecycle
    
//    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        magic("\(self.description).view is loaded   ---------------->")
        
        title = LocalizedStrings.ViewControllerTitles.newMeme
        
        mainView = view as! MemeEditorView
        mainViewViewModel = MemeEditorViewModel()
        
        getFontFromDefaults()
        
        configureNavigationItems()
        configureToolbarItems()
        configureMemeEditorView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /** Will be set if coming from Detail VC */
        if memeToUpdate != nil {
            title = LocalizedStrings.ViewControllerTitles.editMeme
            
            mainViewViewModel.image.value       = memeToUpdate!.image
            mainViewViewModel.topText.value     = memeToUpdate!.topText
            mainViewViewModel.bottomText.value  = memeToUpdate!.bottomText
            mainViewViewModel.font.value        = memeToUpdate!.font
            mainViewViewModel.fontColor.value   = memeToUpdate!.fontColor
            
            meme = memeToUpdate!
        }
    }

    //MARK: - Configuration
    
    /** 
        If coming from Table or Collection view, meme will be nil. If coming
        from Meme Detail VC, we need to prepopulate the image & text fields
    */
    internal func configure(withMeme meme: Meme, atIndex index: Int) {
        memeToUpdate    = meme
        storedIndex     = index
    }
    
    private func configureNavigationItems() {
        
        var shareButtonClosure: BarButtonClosure?
        
        if memeToUpdate == nil {
            /** This is a new meme, so add a share button */
            shareButtonClosure = { [unowned self] in
                
                guard let image = self.createImage() as UIImage! else  { fatalError("error creating image") }
                
                /** If share is successful */
                self.activitySuccessCompletion = {
                    
                    /** Save new meme to storage */
                    self.meme.memedImage = image
                
                    self.storedMemesProvider.addNewMemeToStorage(self.meme, completion: nil)

                    /** close meme editor */
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                /** Open Activity View Controller */
                self.activityViewController = self.getActivityViewController(withImage: image)
                
                self.presentViewController(self.activityViewController!, animated: true, completion: nil)
            }
        }
        
        
        let saveButtonClosure = { [unowned self] in
            guard let image = self.createImage() as UIImage! else  { fatalError("error creating image") }
           
            self.meme.memedImage = image
            
            /** Save the meme to storage */
            if self.memeToUpdate == nil {
                
                /** It's a new meme */
               
                self.storedMemesProvider.addNewMemeToStorage(self.meme) {
                    
                    /** close meme editor when finished */
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                /** Ist's an update */
                self.storedMemesProvider.updateMemeFromStorage(atIndex: self.storedIndex!, withMeme: self.meme) {
                    
                    /** close meme editor when finished */
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
        let clearButtonClosure = { [unowned self] in
            //TODO: Probably should pop a warning alert if an image has been selected & text has been entered
            self.mainViewViewModel.image.value = nil
            self.mainView.resetTextFields()
        }
        
        let cancelButtonClosure = { [unowned self] in
            let navController = self.navigationController as! NavigationController
            navController.vcShouldBeDismissed?()
        }
        
        navItem.configure(
            withShareButtonClosure: shareButtonClosure,
            saveButtonClosure: saveButtonClosure,
            clearButtonClosure: clearButtonClosure,
            cancelButtonClosure: cancelButtonClosure,
            stateMachine: stateMachine)
    }
    
    private func configureToolbarItems() {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            cameraButtonClosure = { [unowned self] in
                self.cameraButtonTapped()
            }
        }
        
        albumButtonClosure = { [unowned self] in
            self.albumButtonTapped()
        }
        
        fontButtonClosure = { [unowned self] (button: UIBarButtonItem) in
            self.fontButtonTapped(button)
        }
        
        fontColorButtonClosure = { [unowned self] (button: UIBarButtonItem) in
            self.fontColorButtonTapped(button)
        }
    }

    private func configureImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    private func configureMemeEditorView() {
        
        let memeImageUpdatedClosure = { [unowned self] (newImage: UIImage?) -> Void in
            /** Update image */
            self.meme.image = newImage
            
            /**
             * If editing an existing meme, need to set that image as well so it
             * doesn't get reset back to old image in viewWillAppear()
             */
            if self.memeToUpdate != nil {
                self.memeToUpdate!.image = newImage
            }
        }
        
        let memeTextUpdatedClosure = { [unowned self] (topText: String, bottomText: String) -> Void in
            self.meme.topText      = topText
            self.meme.bottomText   = bottomText
        }
        
        let memeFontUpdatedClosure = { [unowned self] (newFont: UIFont) -> Void in
            /** Update image */
            self.meme.font = newFont
        }
        
        let memeFontColorUpdatedClosure = { [unowned self] (newColor: UIColor) -> Void in
            /** Update image */
            self.meme.fontColor = newColor
        }
        
        mainView.configure(
            withStateMachine: stateMachine,
            dataSource: mainViewViewModel,
            albumButtonClosure: albumButtonClosure,
            cameraButtonClosure: cameraButtonClosure,
            fontButtonClosure: fontButtonClosure,
            fontColorButtonClosure: fontColorButtonClosure,
            memeImageUpdatedClosure: memeImageUpdatedClosure,
            memeTextUpdatedClosure: memeTextUpdatedClosure,
            memeFontUpdatedClosure: memeFontUpdatedClosure,
            memeFontColorUpdatedClosure: memeFontColorUpdatedClosure)
    }
    
    //MARK: - Actions
    
    
    /** Toolbar Actions */
    private func cameraButtonTapped() {
        configureImagePicker()
        imagePickerController.sourceType = .Camera
        presentImagePicker()
    }
    
    private func albumButtonTapped() {
        configureImagePicker()
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
        let storyboard = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil)
        
        let fontListTableVC = storyboard.instantiateViewControllerWithIdentifier(Constants.StoryBoardID.fontListTableVC) as! FontListTableViewController
        fontListTableVC.preferredContentSize = CGSizeMake(250, 300)
        fontListTableVC.configure(withViewModel: mainViewViewModel)
        fontListTableVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        presentPopover(withViewController: fontListTableVC, fromButton: button)
    }
    
    private func fontColorButtonTapped(button: UIBarButtonItem) {
        /** Present a popover with available font colors */
        let storyboard = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil)
        
        let fontColorsVC = storyboard.instantiateViewControllerWithIdentifier(Constants.StoryBoardID.fontColorSelectionVC) as! FontColorSelectionViewController
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
    
    private func getFontFromDefaults() {
        if let fontName = Constants.userDefaults.stringForKey(Constants.StorageKeys.fontName) as String! {
            var i = 0
            for name in Constants.FontFamilyNameArray {
                if name == fontName {
                    mainViewViewModel.font.value = Constants.FontArray[i]
                }
                i += 1
            }
        } else {
            /** Default font */
            mainViewViewModel.font.value =  Constants.Font.impact
        }
        
        if let fontColor = Constants.userDefaults.stringForKey(Constants.StorageKeys.fontColor) as String! {
            var i = 0
            for color in Constants.FontColorStringArray {
                if color == fontColor {
                    mainViewViewModel.fontColor.value = Constants.FontColorArray[i]
                }
                i += 1
            }
        } else {
            /** Default color */
            mainViewViewModel.fontColor.value =  Constants.ColorScheme.white
        }
    }
    
    private func createImage() -> UIImage {
        /** Hide unedited field before taking snapshot */
        mainView.hidePlaceholderText()
        
        let info = mainView.getInfoForImageContext()
        
        /** Correct for height of navigationBar */
        var correctedY = info.y + CGFloat(navigationController!.navigationBar.frame.size.height)
        
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
}

//MARK: - UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    internal func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        /** Update viewModel so view can update itself */
        mainViewViewModel.image.value = image
        
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

        coordinator.animateAlongsideTransition({ [unowned self] (context: UIViewControllerTransitionCoordinatorContext!) in
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
