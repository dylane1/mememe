//
//  ViewController.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//


import UIKit
import MobileCoreServices

final class MemeEditorViewController: UIViewController, ActivityViewControllerPresentable {
    
    /** Set in MemeEditorPresentable protocol extension */
    var vcShouldBeDismissed: BarButtonClosure!
    
    fileprivate var meme = Meme()
    
    /** View */
    fileprivate var mainView: MemeEditorView!
    fileprivate var mainViewViewModel: MemeEditorViewModel!
    
    /** Navigation */
    @IBOutlet weak var navItem: MemeEditorNavigationItem!
    
    /** For keeping track of app state and enabling/disabling navbar buttons */
    fileprivate var stateMachine = MemeEditorStateMachine()
    
    /** Toolbar button closures (passed to mainView & its toolbar) */
    fileprivate var cameraButtonClosure: BarButtonClosure?
    fileprivate var albumButtonClosure: BarButtonClosure!
    fileprivate var fontButtonClosure: BarButtonClosureWithButtonItemSource!
    fileprivate var fontColorButtonClosure: BarButtonClosureWithButtonItemSource!
    
    /** Picking an image */
    fileprivate lazy var imagePickerController = UIImagePickerController()
    
    /** ActivityViewControllerPresentable -- For Sharing */
    internal var activityViewController: UIActivityViewController?
    internal var activitySuccessCompletion: (() -> Void)? = nil
    
    /** Saving to storage & editing */
    fileprivate lazy var storedMemesProvider = MemesProvider()
    fileprivate var storedIndex: Int?
    fileprivate var memeToUpdate: Meme?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** Set default system font for the title */
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        title = LocalizedStrings.ViewControllerTitles.newMeme
        
        mainView = view as! MemeEditorView
        mainViewViewModel = MemeEditorViewModel()
        
        getFontFromDefaults()
        
        configureNavigationItems()
        configureToolbarItems()
        configureMemeEditorView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
     * If coming from Meme Detail VC, we need to pre-populate
     * the image & text fields.
    */
    internal func configure(withMeme meme: Meme, atIndex index: Int) {
        memeToUpdate    = meme
        storedIndex     = index
    }
    
    fileprivate func configureNavigationItems() {
        
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
                    self.dismiss(animated: true, completion: nil)
                }
                
                /** Open Activity View Controller */
                self.activityViewController = self.getActivityViewController(withImage: image)
                
                self.present(self.activityViewController!, animated: true, completion: nil)
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
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                /** Ist's an update */
                self.storedMemesProvider.updateMemeFromStorage(atIndex: self.storedIndex!, withMeme: self.meme) {
                    
                    /** close meme editor when finished */
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        let clearButtonClosure = { [unowned self] in
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
    
    fileprivate func configureToolbarItems() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
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

    fileprivate func configureImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    fileprivate func configureMemeEditorView() {
        
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
            self.meme.font = newFont
        }
        
        let memeFontColorUpdatedClosure = { [unowned self] (newColor: UIColor) -> Void in
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
    fileprivate func cameraButtonTapped() {
        configureImagePicker()
        imagePickerController.sourceType = .camera
        presentImagePicker()
    }
    
    fileprivate func albumButtonTapped() {
        configureImagePicker()
        imagePickerController.sourceType = .photoLibrary
        presentImagePicker()
    }
    
    fileprivate func presentImagePicker() {
        if presentedViewController == nil {
            present(imagePickerController, animated: true, completion: nil)
        } else {
            dismiss(animated: true) {
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func fontButtonTapped(_ button: UIBarButtonItem) {
        /** Present a popover with available fonts */
        let storyboard = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil)
        
        let fontListTableVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryBoardID.fontListTableVC) as! FontListTableViewController
        fontListTableVC.preferredContentSize = CGSize(width: 250, height: 300)
        fontListTableVC.configure(withViewModel: mainViewViewModel)
        fontListTableVC.modalPresentationStyle = UIModalPresentationStyle.popover
        
        presentPopover(withViewController: fontListTableVC, fromButton: button)
    }
    
    fileprivate func fontColorButtonTapped(_ button: UIBarButtonItem) {
        /** Present a popover with available font colors */
        let storyboard = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil)
        
        let fontColorsVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryBoardID.fontColorSelectionVC) as! FontColorSelectionViewController
        fontColorsVC.preferredContentSize = CGSize(width: 260, height: 116)
        fontColorsVC.configure(withViewModel: mainViewViewModel)
        fontColorsVC.modalPresentationStyle = UIModalPresentationStyle.popover
        
        presentPopover(withViewController: fontColorsVC, fromButton: button)
    }
    
    fileprivate func presentPopover(withViewController vc: UIViewController, fromButton button: UIBarButtonItem) {
        let popoverController = vc.popoverPresentationController!
        popoverController.barButtonItem = button
        popoverController.permittedArrowDirections = .any
        popoverController.delegate = self
        popoverController.backgroundColor = Constants.ColorScheme.whiteAlpha50
        
        if presentedViewController == nil {
            present(vc, animated: true, completion: nil)
        } else {
            dismiss(animated: true) {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func getFontFromDefaults() {
        if let fontName = Constants.userDefaults.string(forKey: Constants.StorageKeys.fontName) as String! {
            var i = 0
            for name in Constants.FontFamilyNameArray {
                if name == fontName {
                    mainViewViewModel.font.value = Constants.FontArray[i]
                    
                    /**
                     * Need to set in meme because the closure hasn't been
                     * configured in view yet
                     */
                    meme.font = Constants.FontArray[i]
                }
                i += 1
            }
        } else {
            /** Default font */
            mainViewViewModel.font.value =  Constants.Font.impact
        }
        
        if let fontColor = Constants.userDefaults.string(forKey: Constants.StorageKeys.fontColor) as String! {
            var i = 0
            for color in Constants.FontColorStringArray {
                if color == fontColor {
                    mainViewViewModel.fontColor.value = Constants.FontColorArray[i]
                    
                    /** 
                     * Need to set in meme because the closure hasn't been 
                     * configured in view yet 
                     */
                    meme.fontColor = Constants.FontColorArray[i]
                }
                i += 1
            }
        } else {
            /** Default color */
            mainViewViewModel.fontColor.value =  Constants.ColorScheme.white
        }
    }
    
    fileprivate func createImage() -> UIImage {
        /** Hide unedited field before taking snapshot */
        mainView.hidePlaceholderText()
        
        let info = mainView.getInfoForImageContext()
        
        /** Correct for height of navigationBar */
        
        var correctedY = info.y + CGFloat(navigationController!.navigationBar.frame.size.height)
        
        /**
         * If status bar is visible, also correct for it
         */
        if !UIApplication.shared.isStatusBarHidden {
            correctedY += UIApplication.shared.statusBarFrame.size.height
        }
        
        UIGraphicsBeginImageContextWithOptions(info.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: -info.x, y: -correctedY)
        view.layer.render(in: context)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenShot!
    }
}

//MARK: - UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        /** Update viewModel so view can update itself */
        mainViewViewModel.image.value = image
        
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
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
    case landscape, portrait
}

//MARK: - UIContentContainer
extension MemeEditorViewController {
    /** Tell view to update constraints on text fields upon rotation */    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let newOrientation: DestinationOrientation = (size.width > size.height) ? .landscape : .portrait

        coordinator.animate(alongsideTransition: { [unowned self] (context: UIViewControllerTransitionCoordinatorContext!) in
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
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
