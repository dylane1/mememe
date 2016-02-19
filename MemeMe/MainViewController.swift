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

    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            magic("image saved to photos album")
            
            /** Reset everything */
            mainViewViewModel.image.value = nil
            mainView.resetTextFields()
            
            
            
            
            
//            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
        } else {
            magic("error: \(error?.localizedDescription)")
//            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
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
            
            /** Save the screenShot */
            UIImageWriteToSavedPhotosAlbum(imageToShare, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
            /** Open Activity View Controller */
            let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            
            /** Set completion handler for Share */
            activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                magic("activityType: \(activityType), completed: \(completed), returnedItems: \(returnedItems), activityError: \(activityError)")
                
                if completed {
                    magic("completed!")
                } else {
                    magic("Did not complete share activity")
                    
                    if activityError != nil { magic("error: \(activityError?.localizedDescription)") }
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
        /** Hide unedited field before taking snapshot */
        mainView.hidePlaceholderText()
        
        UIGraphicsBeginImageContext(self.view.bounds.size);
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenShot
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





























