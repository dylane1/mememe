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
    
    typealias FontButtonClosure = (UIBarButtonItem) -> Void
    private var fontButtonClosure: FontButtonClosure?
    private var fontButton: UIBarButtonItem!
    
    typealias MemeTextUpdated = (Meme) -> Void
    private var memeTextUpdatedClosure: MemeTextUpdated?
    
    typealias MemeImageUpdated = (Meme, UIImage?) -> Meme
    private var memeImageUpdatedClosure: MemeImageUpdated?
    
    private var meme = Meme()
    
    private var image: UIImage? = nil {
        didSet {
            /** Set image in imageView */
            imageView.image = image
            
            /** 
             Update text field constraints for new image at current orientation 
             */
            let orientation: DestinationOrientation
            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                orientation = .Landscape
            } else {
                orientation = .Portrait
            }
            updateTextFieldContstraints(withNewOrientation: orientation)
            
            meme = memeImageUpdatedClosure!(meme, image)
            
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
            meme.topText = topText
            memeTextUpdatedClosure?(meme)
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    private var bottomText: String? = "" {
        didSet {
            meme.bottomText = bottomText
            memeTextUpdatedClosure?(meme)
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    
    private var font: UIFont = Constants.Fonts.impact {
        didSet {
            /** Update text field fonts */
            configureTextFieldAttributes()
        }
    }
    
    private var textFieldAttributes = [
        NSForegroundColorAttributeName: Constants.ColorScheme.white,
        NSStrokeColorAttributeName:     Constants.ColorScheme.black,
        NSStrokeWidthAttributeName:     -5.0
    ]
    
    private var dataSource: MainViewViewModel! {
        didSet {
            dataSource.image.bind { [unowned self] in
                self.image = $0
            }
            dataSource.font.bindAndFire { [unowned self] in
                self.font = $0
            }
        }
    }
    
    private var stateMachine: StateMachine!
    
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var topFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topFieldTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFieldTrailingConstraint: NSLayoutConstraint!
    
    
    //MARK: - Internal funk(s)
    
    internal func configure(
        withDataSource dataSource: MainViewViewModel,
        albumButtonClosure: BarButtonClosure,
        cameraButtonClosure: BarButtonClosure? = nil,
        fontButtonClosure: FontButtonClosure,
        memeTextUpdatedClosure: MemeTextUpdated,
        memeImageUpdatedClosure: MemeImageUpdated,
        stateMachine: StateMachine)
    {
        self.dataSource              = dataSource
        self.albumButtonClosure      = albumButtonClosure
        self.cameraButtonClosure     = cameraButtonClosure
        self.fontButtonClosure       = fontButtonClosure
        self.memeTextUpdatedClosure  = memeTextUpdatedClosure
        self.memeImageUpdatedClosure = memeImageUpdatedClosure
        self.stateMachine            = stateMachine
        
        configureToolbarItems()
        configureTextFields()
    }

    internal func cameraButtonTapped() {
        cameraButtonClosure?()
    }
    
    internal func albumButtonTapped() {
        albumButtonClosure?()
    }
    
    internal func fontButtonTapped() {
        fontButtonClosure?(fontButton)
    }
    
    internal func resetTextFields() {
        topText     = nil
        bottomText  = nil
        
        topField.endEditing(true)
        bottomField.endEditing(true)

        /** Reset constraints */
        topFieldLeadingConstraint.constant  = 0
        topFieldTopConstraint.constant      = 8
        topFieldTrailingConstraint.constant = 0
        
        bottomFieldLeadingConstraint.constant   = 0
        bottomFieldBottomConstraint.constant    = 52
        bottomFieldTrailingConstraint.constant  = 0
        
        showPlaceholderText()
        configureTextFields()
    }

    internal func hidePlaceholderText() {
        /** Hide unedited field if taking snapshot of view to share */
        topField.alpha      = (topText == "" || topText == nil) ? 0 : 1
        bottomField.alpha   = (bottomText == "" || bottomText == nil) ? 0 : 1
    }
    
    internal func showPlaceholderText() {
        topField.alpha      = 1
        bottomField.alpha   = 1
    }
    
    //MARK: - Private funk(s)

    private func configureToolbarItems() {
        var toolbarItemArray = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbarItemArray.append(flexSpace)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 44
        
        let cameraButton = UIBarButtonItem(
            barButtonSystemItem: .Camera,
            target: self,
            action: "cameraButtonTapped")
        
        cameraButton.enabled = false

        toolbarItemArray.append(cameraButton)
        toolbarItemArray.append(fixedSpace)

        if UIImagePickerController.isSourceTypeAvailable(.Camera) { cameraButton.enabled = true }
        
        let albumButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.album,
            style: .Plain,
            target: self,
            action: "albumButtonTapped")
        
        toolbarItemArray.append(albumButton)
        toolbarItemArray.append(fixedSpace)
        
        fontButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.font,
            style: .Plain,
            target: self,
            action: "fontButtonTapped")
        
        toolbarItemArray.append(fontButton)
        toolbarItemArray.append(flexSpace)
        
        toolbar.setItems(toolbarItemArray, animated: false)
        
        toolbar.barTintColor = Constants.ColorScheme.white
        toolbar.tintColor    = Constants.ColorScheme.darkBlue
        toolbar.translucent  = true
    }
    
    private func configureTextFields() {
        topField.delegate                   = self
        topField.borderStyle                = .None
        topField.backgroundColor            = UIColor.clearColor()
        topField.returnKeyType              = .Done
        topField.autocapitalizationType     = .AllCharacters
        topField.adjustsFontSizeToFitWidth  = true
        
        bottomField.delegate                    = self
        bottomField.borderStyle                 = .None
        bottomField.backgroundColor             = UIColor.clearColor()
        bottomField.returnKeyType               = .Done
        bottomField.autocapitalizationType      = .AllCharacters
        bottomField.adjustsFontSizeToFitWidth   = true
        
        /** For resetting when 'Cancel' is tapped */
        topField.attributedText     = nil
        bottomField.attributedText  = nil
        
        configureTextFieldAttributes()
    }
    
    internal func configureTextFieldAttributes() {

        textFieldAttributes[NSFontAttributeName] = font
        
        let placeholderAttributes = [
            NSForegroundColorAttributeName: Constants.ColorScheme.whiteAlpha50,
            NSFontAttributeName:            font
        ]
        
        topField.defaultTextAttributes  = textFieldAttributes
        topField.attributedPlaceholder  = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.top, attributes: placeholderAttributes)
        topField.textAlignment          = .Center //Must be set after the string is set in order to work...
        
        bottomField.defaultTextAttributes   = textFieldAttributes
        bottomField.attributedPlaceholder   = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.bottom, attributes: placeholderAttributes)
        bottomField.textAlignment           = .Center
    }
    
    internal func updateTextFieldContstraints(withNewOrientation orientation: DestinationOrientation) {
        //FIXME: Find a better solution to text field location on rotation issue: http://smnh.me/synchronizing-rotation-animation-between-the-keyboard-and-the-attached-view-part-2/
        /** Close keyboard on rotation */
        if bottomField.isFirstResponder() {
            bottomField.resignFirstResponder()
        }

        if imageView.image == nil { return }

        if orientation == .Landscape {
            /** Landscape */
            topFieldTopConstraint.constant          = 8
            bottomFieldBottomConstraint.constant    = 52
            
            let correctWidth = (imageView.frame.height / imageView.image!.size.height) * imageView.image!.size.width
            
            let newConstant = (imageView.frame.width - correctWidth) / 2
            topFieldLeadingConstraint.constant      = newConstant
            topFieldTrailingConstraint.constant     = newConstant
            bottomFieldLeadingConstraint.constant   = newConstant
            bottomFieldTrailingConstraint.constant  = newConstant
        } else {
            /** Portrait */
            topFieldLeadingConstraint.constant      = 0
            topFieldTrailingConstraint.constant     = 0
            bottomFieldLeadingConstraint.constant   = 0
            bottomFieldTrailingConstraint.constant  = 0
            
            let correctHeight = (imageView.frame.width / imageView.image!.size.width) * imageView.image!.size.height

            let newConstant = ((imageView.frame.height - correctHeight) / 2)
            topFieldTopConstraint.constant          = newConstant + 8
            bottomFieldBottomConstraint.constant    = newConstant + 52
        }
    }
    
    internal func getInfoForImageContext() -> (size: CGSize, x: CGFloat, y: CGFloat) {
        
        let multiplier: CGFloat
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            /** Landscape: height is constricted */
            multiplier = imageView.frame.height / imageView.image!.size.height
        } else {
            /** Portrait: width is constricted */
            multiplier = imageView.frame.width / imageView.image!.size.width
        }
        
        let width = imageView.image!.size.width * multiplier
        let height = imageView.image!.size.height * multiplier
        
        let x: CGFloat
        if width >= imageView.frame.width {
            x = 0
        } else {
            x = (imageView.frame.width - width) / 2
        }
        
        let y: CGFloat
        if height >= imageView.frame.height {
            y = 0
        } else {
            y = (imageView.frame.height - height) / 2
        }
        
        return (size: CGSizeMake(width, height), x: x, y: y)
    }
}


//MARK: - UITextFieldDelegate

extension MainView: UITextFieldDelegate {
    
    internal func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        stateMachine.state.value = .IsEditingText
        
        /** 
         * For some reason defaultTextAttributes get changed if you tap into
         * the field, don't type anything, then tap 'Done' on the keyboard. This
         * fixes that scenario.
        */
        textField.defaultTextAttributes  = textFieldAttributes
        textField.textAlignment          = .Center
        
        /** Remove placeholder text */
        textField.placeholder = nil
        
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
        
        //FIXME: Get rotation working correctly
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: Selector("keyboardWillChangeFrame:"),
//            name: UIKeyboardWillChangeFrameNotification,
//            object: nil)
        
        return true
    }
    
    internal func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    internal func textFieldDidEndEditing(textField: UITextField) {
        topText     = topField.text as String?
        bottomText  = bottomField.text as String?
    }
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    internal func keyboardWillShow(notification: NSNotification) {
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
    
    internal func keyboardWillHide(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        //FIXME: Get rotation working correctly
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        /** Animate view back down if done editing the bottom text field */
        if bottomField.editing {
            UIView.animateWithDuration(0.5) {
                var frame       = self.frame
                frame.origin.y  = 0.0
                self.frame      = frame
            }
        }
    }
    //FIXME: Get rotation working correctly
    //See: http://smnh.me/synchronizing-rotation-animation-between-the-keyboard-and-the-attached-view-part-2/
//    internal func keyboardWillChangeFrame(notification: NSNotification) {
//        magic("")
//        if bottomField.editing {
//            let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
//            
//            UIView.animateWithDuration(0.5) {
//                var frame       = self.frame
//                frame.origin.y  = -(keyboardSize?.height)!
//                self.frame      = frame
//            }
//        }
//    }
}



