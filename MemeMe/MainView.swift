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
        memeTextUpdatedClosure: MemeTextUpdated,
        memeImageUpdatedClosure: MemeImageUpdated,
        stateMachine: StateMachine)
    {
        self.dataSource              = dataSource
        self.albumButtonClosure      = albumButtonClosure
        self.cameraButtonClosure     = cameraButtonClosure
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
    
    internal func resetTextFields() {
        topText     = nil
        bottomText  = nil
        
        topField.endEditing(true)
        bottomField.endEditing(true)
        
        topField.alpha      = 1
        bottomField.alpha   = 1
        
        /** Reset constraints */
        topFieldLeadingConstraint.constant = 0
        topFieldTopConstraint.constant = 16
        topFieldTrailingConstraint.constant = 0
        
        bottomFieldLeadingConstraint.constant = 0
        bottomFieldBottomConstraint.constant = 16
        bottomFieldTrailingConstraint.constant = 0
        
        configureTextFields()
    }

    internal func hidePlaceholderText() {
        /** Hide unedited field if taking snapshot of view to share */
        topField.alpha      = (topText == "" || topText == nil) ? 0 : 1
        bottomField.alpha   = (bottomText == "" || bottomText == nil) ? 0 : 1
    }
    
//    override func drawRect(rect: CGRect) {
//        magic("topFieldTopConstraint.constant: \(topFieldTopConstraint.constant)")
//        magic("bottomFieldBottomConstraint.constant: \(bottomFieldBottomConstraint.constant)")
//        magic("bottomFieldLeadingConstraint.constant: \(bottomFieldLeadingConstraint.constant)")
//    }
    //MARK: - Private funk(s)
    /*******************************************************************************
    * February 26, 2016 ENDPOINT
    
      Need to allow users to choose a font. look here: http://iosfonts.com
        
      compare with font list
    
    AmericanTypewriter-Bold
    Arial-BoldMT
    AvenirNext-Heavy
    
    *
    *******************************************************************************/
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
            title: LocalizedStrings.NavigationControllerButtons.album,
            style: .Plain,
            target: self,
            action: "albumButtonTapped")
        
        toolbarItemArray.append(albumButton)
        toolbarItemArray.append(flexSpace)
        
        toolbar.setItems(toolbarItemArray, animated: false)
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
        
        let textFieldAttributes = [
            NSForegroundColorAttributeName: Constants.ColorScheme.white,
            NSStrokeColorAttributeName:     UIColor.blackColor(),
            NSStrokeWidthAttributeName:     -5.0,
            NSFontAttributeName:            Constants.Fonts.TextFields.impactFont!
        ]
        
        let placeholderAttributes = [
            NSForegroundColorAttributeName: Constants.ColorScheme.whiteAlpha50,
            NSFontAttributeName:            Constants.Fonts.TextFields.impactFont!
        ]
        
        topField.defaultTextAttributes  = textFieldAttributes
        topField.attributedPlaceholder  = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.top, attributes: placeholderAttributes)
        topField.textAlignment          = .Center //Must be set after the string is set in order to work...
        
        bottomField.defaultTextAttributes   = textFieldAttributes
        bottomField.attributedPlaceholder   = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.bottom, attributes: placeholderAttributes)
        bottomField.textAlignment           = .Center
        
        
        /** Set auto layout constraints */
//        let margins = imageView.image.layoutMarginsGuide

    }
    
    internal func updateTextFieldContstraints(withNewOrientation orientation: DestinationOrientation) {
        if imageView.image == nil {return}
        
        magic("imageView.image!.size.height: \(imageView.image!.size.height)")
        magic("imageView.image!.size.width: \(imageView.image!.size.width)")
        
        if orientation == .Landscape {
            magic("update to landscape")
            /**
            * Need to update text input constraints:
            *
            * Top & Bottom: 16? pts from bars
            * Leading & trailing 8pts inside edges of image
            *
            */
            topFieldTopConstraint.constant = 16
            bottomFieldBottomConstraint.constant = 16
            
            let correctWidth = (imageView.frame.height / imageView.image!.size.height) * imageView.image!.size.width
            
            let newConstant = (imageView.frame.width - correctWidth) / 2
            topFieldLeadingConstraint.constant      = newConstant
            topFieldTrailingConstraint.constant     = newConstant
            bottomFieldLeadingConstraint.constant   = newConstant
            bottomFieldTrailingConstraint.constant  = newConstant
        } else {
            magic("update to portrait")
            /**
            * Need to update text input constraints:
            *
            * Top & Bottom: 16? pts inside edges of image
            * Leading & trailing 8pts from superview
            *
            */
            topFieldLeadingConstraint.constant      = 0
            topFieldTrailingConstraint.constant     = 0
            bottomFieldLeadingConstraint.constant   = 0
            bottomFieldTrailingConstraint.constant  = 0
            
            let correctHeight = (imageView.frame.width / imageView.image!.size.width) * imageView.image!.size.height

            let newConstant = ((imageView.frame.height - correctHeight) / 2) + 16
            topFieldTopConstraint.constant = newConstant
            bottomFieldBottomConstraint.constant = newConstant
        }
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
    
    internal func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
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
extension MainView {
//    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        updateTextFieldContstraints()
//    }
    

//    
//    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection!) {
//        updateConstraintsWithTraitCollection(traitCollection)
//    }
}
