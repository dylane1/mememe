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
    
    private var topText     = ""
    private var bottomText  = ""
    
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
        configureTextFields()
    }

    
    //MARK: - Public funk(s)
    
    func cameraButtonTapped() {
        cameraButtonAction?()
    }
    
    func albumButtonTapped() {
        albumButtonAction?()
    }
    
    func reset() {
        magic("")
        
        topField.endEditing(true)
        bottomField.endEditing(true)
        
        configureTextFields()
        imageView.image = nil
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
    
    private func configureTextFields() {
        topField.delegate           = self
        topField.borderStyle        = .None
        topField.backgroundColor    = UIColor.clearColor()
        topField.returnKeyType      = .Done
        
        bottomField.delegate        = self
        bottomField.borderStyle     = .None
        bottomField.backgroundColor = UIColor.clearColor()
        bottomField.returnKeyType   = .Done
        
        /** For resetting when 'Cancel' is tapped */
        topField.attributedText     = nil
        bottomField.attributedText  = nil
        
        let textFieldAttributes = [
            NSForegroundColorAttributeName: Constants.ColorScheme.white,
            NSFontAttributeName:            Constants.Fonts.textFields
        ]
        
        topField.defaultTextAttributes  = textFieldAttributes
        topField.attributedPlaceholder  = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.top, attributes: textFieldAttributes)
        topField.textAlignment          = .Center //Must be set after the string is set in order to work...
        
        bottomField.defaultTextAttributes   = textFieldAttributes
        bottomField.attributedPlaceholder   = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.bottom, attributes: textFieldAttributes)
        bottomField.textAlignment           = .Center

    }
}

//MARK: - UITextFieldDelegate

extension MainView: UITextFieldDelegate {
    
    /** 
     * Set View rect so bottom text is visible 
     *
     * Adapted from this post on Stack Overflow:
     * http://stackoverflow.com/questions/11282449/move-uiview-up-when-the-keyboard-appears-in-ios
     */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        magic("")
        textField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomField.editing {
            let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
            UIView.animateWithDuration(0.5) {
                var frame = self.frame
                frame.origin.y = -(keyboardSize?.height)!
                self.frame = frame
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        magic("")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        if bottomField.editing {
            UIView.animateWithDuration(0.5) {
                var frame = self.frame
                frame.origin.y = 0.0
                self.frame = frame
            }
        }
    }
}




























