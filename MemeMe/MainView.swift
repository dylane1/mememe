//
//  MainView.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol MainViewDataSource {
    var image: Dynamic<UIImage?> { get }
}

class MainView: UIView {
    typealias ToolbarButtonAction = () -> Void
    private var albumButtonAction: ToolbarButtonAction?
    private var cameraButtonAction: ToolbarButtonAction?
    
    
    private var image: UIImage? = nil {
        didSet {
            /** Set image in imageView */
            imageView.image = image
        }
    }
    
    private var dataSource: MainViewModel! {
        didSet {
            dataSource.image.bind { [unowned self] in
                self.image = $0
            }
        }
    }
    
    
    
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    //MARK: - Public funk(s)
    
    func configure(
        withDataSource viewModel: MainViewModel,
        albumButtonClosure: ToolbarButtonAction,
        cameraButtonClosure: ToolbarButtonAction? = nil)
    {
        dataSource          = viewModel
        albumButtonAction   = albumButtonClosure
        cameraButtonAction  = cameraButtonClosure
        
        configureToolbarItems()
        
    }

    
    //MARK: - Public funk(s)
    
    func cameraButtonTapped() {
        cameraButtonAction?()
    }
    
    func albumButtonTapped() {
        albumButtonAction?()
    }
    
    //MARK: - Private funk(s)
    
    private func configureToolbarItems() {
        var toolbarItemArray = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbarItemArray.append(flexSpace)
        
        /** Only add a camera button if camera is available */
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            fixedSpace.width = 44
            
            let cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "cameraButtonTapped")
            
            toolbarItemArray.append(flexSpace)
            toolbarItemArray.append(cameraButton)
            toolbarItemArray.append(fixedSpace)
        }
        
        let albumButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.album,
            style: .Plain,
            target: self,
            action: "albumButtonTapped")
        
        toolbarItemArray.append(albumButton)
        toolbarItemArray.append(flexSpace)
        
        toolbar.setItems(toolbarItemArray, animated: false)
    }
}




























