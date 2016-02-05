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
    
    private var mainView: MainView!
    private var mainViewModel: MainViewModel!
    
    private let imagePickerController = UIImagePickerController()
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedStrings.ViewControllerTitles.memeMe
        
        mainView = view as! MainView
        mainViewModel = MainViewModel()
        
        configureNavigationItems()
        configureToolbarItems()
        configureImagePicker()
        
        mainView.configure(
            withDataSource: mainViewModel,
            albumButtonClosure: albumButtonClosure,
            cameraButtonClosure: cameraButtonClosure
        )
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
        
        let activityVC = UIActivityViewController(activityItems: ["foo"], applicationActivities: nil)
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func cancelButtonTapped() {
        magic("")
        mainView.reset()
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
    
    private func configureNavigationItems() {

        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonTapped")
        
        navigationItem.leftBarButtonItem = shareButton
        
        let cancelButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.cancel,
            style: .Plain,
            target: self,
            action: "cancelButtonTapped")
        
        navigationItem.rightBarButtonItem = cancelButton
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































