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
    typealias BarButtonClosure = () -> Void
    private var albumButtonClosure: BarButtonClosure?
    private var cameraButtonClosure: BarButtonClosure?
    
    
    private var image: UIImage? = nil {
        didSet {
            /** Set image in imageView */
            imageView.image = image
            
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    /** 
      * Setting this to String? to be consistent with UITextField.text, even
      * though the documentation says that it's set to @"" by default. Not
      * sure why anyone would want to set UITextField.text to nil, but I suppose
      * there's a reason.
     */
    private var topText: String? = "" {
        didSet {
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    private var bottomText: String? = "" {
        didSet {
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    
    private var dataSource: MainViewViewModel! {
        didSet {
            dataSource.image.bind { [unowned self] in
                self.image = $0
            }
        }
    }
    
    private var stateMachine: StateMachine!
    
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    //MARK: - Public funk(s)
    
    func configure(
        withDataSource dataSource: MainViewViewModel,
        albumButtonClosure: BarButtonClosure,
        cameraButtonClosure: BarButtonClosure? = nil,
        stateMachine: StateMachine)
    {
        self.dataSource             = dataSource
        self.albumButtonClosure     = albumButtonClosure
        self.cameraButtonClosure    = cameraButtonClosure
        self.stateMachine           = stateMachine
        
        configureToolbarItems()
        configureTextFields()
    }

    
    //MARK: - Public funk(s)
    
    func cameraButtonTapped() {
        cameraButtonClosure?()
    }
    
    func albumButtonTapped() {
        albumButtonClosure?()
    }
    
    func resetTextFields() {
        topText     = nil
        bottomText  = nil
        
        topField.endEditing(true)
        bottomField.endEditing(true)
        
        configureTextFields()
    }

    //TODO: hide on entering field
    //TODO: hide if user doesn't edit one of the fields
    func hidePlaceholderText() {
        
    }
    
    func showPlaceholderText() {
        //May not need this.
    }
    
    //MARK: - Private funk(s)
    
    private func configureToolbarItems() {
        var toolbarItemArray = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbarItemArray.append(flexSpace)
        
        /** 
         * According to spec: Add camera button but disable if camera not available
         * 
         * Not in spec: Only add a camera button if camera is available
         */
//        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            fixedSpace.width = 44
            
            let cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "cameraButtonTapped")
            cameraButton.enabled = false
        
//            toolbarItemArray.append(flexSpace)
            toolbarItemArray.append(cameraButton)
            toolbarItemArray.append(fixedSpace)
//        }
        if UIImagePickerController.isSourceTypeAvailable(.Camera) { cameraButton.enabled = true }
        
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
        
        //FIXME: text must be all caps
        let textFieldAttributes = [
            NSForegroundColorAttributeName: Constants.ColorScheme.white,
            NSFontAttributeName:            Constants.Fonts.textFields
        ]
        
        let placeholderAttributes = [
            NSForegroundColorAttributeName: Constants.ColorScheme.whiteAlpha50,
            NSFontAttributeName:            Constants.Fonts.textFields
        ]
        
        topField.defaultTextAttributes  = textFieldAttributes
        topField.attributedPlaceholder  = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.top, attributes: placeholderAttributes)
        topField.textAlignment          = .Center //Must be set after the string is set in order to work...
        
        bottomField.defaultTextAttributes   = textFieldAttributes
        bottomField.attributedPlaceholder   = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.bottom, attributes: placeholderAttributes)
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
//        magic("")
        /** Text field is being edited, enable share & cancel buttons */
//        enableNavBarButtonsClosure?()
        
        /** Set up observers */
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
    
//    func textFieldDidBeginEditing(textField: UITextField) {
////        magic("")
//        
//    }
//    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
//        magic("text: \(textField.text); topField.text: \(topField.text); bottomField.text: \(bottomField.text)")
        
        topText     = topField.text as String?
        bottomText  = bottomField.text as String?
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        /** Animate the view up so bottom text field is visible while editing */
        if bottomField.editing {
            let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
            
            UIView.animateWithDuration(0.5) {
                var frame       = self.frame
                frame.origin.y  = -(keyboardSize?.height)!
                self.frame      = frame
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        /** Animate view back down if done editing the bottom text field */
        if bottomField.editing {
            UIView.animateWithDuration(0.5) {
                var frame       = self.frame
                frame.origin.y  = 0.0
                self.frame      = frame
            }
        }
    }
}




























