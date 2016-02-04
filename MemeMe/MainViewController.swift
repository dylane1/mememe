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
    private var mainView: MainView!
    private var mainViewModel: MainViewModel!
    
    private let imagePickerController = UIImagePickerController()
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedStrings.ViewControllerTitles.memeMe
        
        mainView = view as! MainView
        mainViewModel = MainViewModel()
        
        mainView.configure(withDataSource: mainViewModel)
        
        setupNavigationItems()
        setupToolbarItems()
        configureImagePicker()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.setToolbarHidden(false, animated: false)
        magic("imageView.frame: \(mainView.frame); bounds: \(mainView.bounds)")
    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//    }
    
    //MARK: - Public funk(s)
    
    /** Navigation Bar Actions */
    func shareButtonTapped() {
        magic("")
    }
    
    func cancelButtonTapped() {
        magic("")
    }
    
    /** Toolbar Actions */
    func cameraButtonTapped() {
        magic("")
        imagePickerController.sourceType = .Camera
        //TODO: Custom animation
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func albumButtonTapped() {
        magic("")
        imagePickerController.sourceType = .PhotoLibrary
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
     
     
    //MARK: - Private funk(s)
    
    private func setupNavigationItems() {

        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonTapped")
        
        navigationItem.leftBarButtonItem = shareButton
        
        let cancelButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.cancel,
            style: .Plain,
            target: self,
            action: "cancelButtonTapped")
        
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func setupToolbarItems() {
//        var toolbarItemArray = [UIBarButtonItem]()
//        
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        
//        toolbarItemArray.append(flexSpace)
//        
//        /** Only add a camera button if camera is available */
//        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
//            let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
//            fixedSpace.width = 44
//            
//            let cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "cameraButtonTapped")
//            
//            toolbarItemArray.append(flexSpace)
//            toolbarItemArray.append(cameraButton)
//            toolbarItemArray.append(fixedSpace)
//        }
//        
//        let albumButton = UIBarButtonItem(
//            title: LocalizedStrings.NavigationControllerButtons.album,
//            style: .Plain,
//            target: self,
//            action: "albumButtonTapped")
//        
//        toolbarItemArray.append(albumButton)
//        toolbarItemArray.append(flexSpace)
//        
//        setToolbarItems(toolbarItemArray, animated: true)
    }
    
    
    private func configureImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
}

//MARK: - UINavigationControllerDelegate
extension MainViewController: UINavigationControllerDelegate {
    
}

//MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        magic("selected image: \(image)")
        mainViewModel.image.value = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}































