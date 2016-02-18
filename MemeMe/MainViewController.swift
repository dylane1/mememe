//
//  ViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

//TODO: Camera button must be there & disabled on simulator

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

    
    
    /** Navigation Bar Actions */

    
    func savedCompletion() {
        magic("image saved to photos album")
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
            magic("")
            
            let imageToShare = self!.createImage()
            
            let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            
            activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                if completed {
                    magic("completed!")
                    UIImageWriteToSavedPhotosAlbum(imageToShare, self!, "savedCompletion", nil)
                } else {
                    magic("error: \(activityError)")
                }
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
     
        /** Only add a camera button if camera is available */
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
        //TODO: If share is tapped when no text has been set, hide the placeholder text before creating image
        mainView.hidePlaceholderText()
        
        
        UIGraphicsBeginImageContext(self.view.bounds.size);
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenShot
    }
}

//MARK: - UINavigationControllerDelegate
extension MainViewController: UINavigationControllerDelegate {
    /**
    * Need this in order to set self as UIImagePikerController delegate 
    * in configureImagePicker()
    */
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































