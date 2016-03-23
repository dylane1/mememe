//
//  MainView.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol MemeEditorViewDataSource {
    var image: Dynamic<UIImage?> { get }
    var topText: Dynamic<String> { get }
    var bottomText: Dynamic<String> { get }
    var font: Dynamic<UIFont> { get }
    var fontColor: Dynamic<UIColor> { get }
}

final class MemeEditorView: UIView {
    typealias BarButtonClosure = () -> Void
    private var albumButtonClosure: BarButtonClosure?
    private var cameraButtonClosure: BarButtonClosure?
    
    private var fontButtonClosure: BarButtonClosureReturningButtonSource?
    private var fontButton: UIBarButtonItem!
    private var fontColorButtonClosure: BarButtonClosureReturningButtonSource?
    private var fontColorButton: UIBarButtonItem!
    
    typealias MemeTextUpdated = (String, String) -> Void
    private var memeTextUpdatedClosure: MemeTextUpdated?
    
    typealias MemeImageUpdated = (UIImage?) -> Void
    private var memeImageUpdatedClosure: MemeImageUpdated?
    
    typealias MemeFontUpdated = (UIFont) -> Void
    private var memeFontUpdatedClosure: MemeFontUpdated?
    
    typealias MemeFontColorUpdated = (UIColor) -> Void
    private var memeFontColorUpdatedClosure: MemeFontColorUpdated?
    
    
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
            
            memeImageUpdatedClosure?(image)
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    
    private var topText = "" {
        didSet {
//            meme.topText = topText
//            memeTextUpdatedClosure?(meme)
//            topField.text = topText
//            topField.alpha = 1.0
            memeTextUpdatedClosure?(topText, bottomText)
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    private var bottomText = "" {
        didSet {
//            meme.bottomText = bottomText
//            memeTextUpdatedClosure?(meme)
//            bottomField.text = bottomText
//            bottomField.alpha = 1.0
            memeTextUpdatedClosure?(topText, bottomText)
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
//            setNeedsDisplay()
        }
    }
    
    private var font: UIFont = Constants.Font.impact {
        didSet {
            magic("set font & about to call closure: \(font)")
            memeFontUpdatedClosure?(font)
            
            /** Update text field fonts */
            configureTextFieldAttributes()
        }
    }
    
    private var fontColor: UIColor = Constants.ColorScheme.white {
        didSet {
            memeFontColorUpdatedClosure?(fontColor)
            
            /** Update text field fonts */
            configureTextFieldAttributes()
        }
    }
    
    private var textFieldAttributes = [
        NSStrokeColorAttributeName:     Constants.ColorScheme.black,
        NSStrokeWidthAttributeName:     -5.0
    ]
    
    private var dataSource: MemeEditorViewModel! {
        didSet {
            dataSource.image.bind { [unowned self] in
//                magic("image: \($0)")
                self.image = $0
            }
            dataSource.topText.bind { [unowned self] in
//                magic("topText: \($0)")
                self.topText = $0
            }
            dataSource.bottomText.bind { [unowned self] in
//                magic("bottomText: \($0)")
                self.bottomText = $0
            }
            dataSource.font.bindAndFire { [unowned self] in
//                magic("font: \($0)")
                self.font = $0
            }
            dataSource.fontColor.bindAndFire { [unowned self] in
//                magic("fontColor: \($0)")
                self.fontColor = $0
            }
        }
    }
    
    private var stateMachine: MemeEditorStateMachine!
    
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
    
    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    //MARK: - Configuration
    
    internal func configure(
        withStateMachine stateMachine: MemeEditorStateMachine,
        dataSource: MemeEditorViewModel,
        albumButtonClosure: BarButtonClosure,
        cameraButtonClosure: BarButtonClosure? = nil,
        fontButtonClosure: BarButtonClosureReturningButtonSource,
        fontColorButtonClosure: BarButtonClosureReturningButtonSource,
        memeImageUpdatedClosure: MemeImageUpdated,
        memeTextUpdatedClosure: MemeTextUpdated,
        memeFontUpdatedClosure: MemeFontUpdated,
        memeFontColorUpdatedClosure: MemeFontColorUpdated)
    {
        self.stateMachine                   = stateMachine
        self.dataSource                     = dataSource
        self.albumButtonClosure             = albumButtonClosure
        self.cameraButtonClosure            = cameraButtonClosure
        self.fontButtonClosure              = fontButtonClosure
        self.fontColorButtonClosure         = fontColorButtonClosure
        self.memeImageUpdatedClosure        = memeImageUpdatedClosure
        self.memeTextUpdatedClosure         = memeTextUpdatedClosure
        self.memeFontUpdatedClosure         = memeFontUpdatedClosure
        self.memeFontColorUpdatedClosure    = memeFontColorUpdatedClosure
        
        configureToolbarItems()
        configureTextFields()
    }

    private func configureToolbarItems() {
        var toolbarItemArray = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbarItemArray.append(flexSpace)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 20
        
        let cameraButton = UIBarButtonItem(
            barButtonSystemItem: .Camera,
            target: self,
            action: #selector(cameraButtonTapped))
        
        cameraButton.enabled = false
        
        toolbarItemArray.append(cameraButton)
        toolbarItemArray.append(fixedSpace)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) { cameraButton.enabled = true }
        
        let albumButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.album,
            style: .Plain,
            target: self,
            action: #selector(albumButtonTapped))
        
        toolbarItemArray.append(albumButton)
        toolbarItemArray.append(fixedSpace)
        
        fontButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.font,
            style: .Plain,
            target: self,
            action: #selector(fontButtonTapped))
        
        toolbarItemArray.append(fontButton)
        toolbarItemArray.append(fixedSpace)
        
        fontColorButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.color,
            style: .Plain,
            target: self,
            action: #selector(fontColorButtonTapped))
        
        toolbarItemArray.append(fontColorButton)
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
        showPlaceholderText()
    }
    
    internal func configureTextFieldAttributes() {
        
        textFieldAttributes[NSFontAttributeName] = font
        textFieldAttributes[NSForegroundColorAttributeName] = fontColor
        
        let placeholderAttributes = [
            NSForegroundColorAttributeName: fontColor,
            NSFontAttributeName:            font
        ]
        
        topField.defaultTextAttributes  = textFieldAttributes
        topField.attributedPlaceholder  = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.top, attributes: placeholderAttributes)
        topField.textAlignment          = .Center //Must be set after the string is set in order to work...
        
        bottomField.defaultTextAttributes   = textFieldAttributes
        bottomField.attributedPlaceholder   = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.bottom, attributes: placeholderAttributes)
        bottomField.textAlignment           = .Center
    }
    
    
    //MARK: - Actions
    
    internal func cameraButtonTapped() {
        cameraButtonClosure?()
    }
    
    internal func albumButtonTapped() {
        albumButtonClosure?()
    }
    
    internal func fontButtonTapped() {
        fontButtonClosure?(fontButton)
    }
    
    internal func fontColorButtonTapped() {
        fontColorButtonClosure?(fontColorButton)
    }
    
    internal func resetTextFields() {
        topText     = ""
        bottomText  = ""
        
        topField.endEditing(true)
        bottomField.endEditing(true)

        /** Reset constraints */
        topFieldLeadingConstraint.constant  = 0
        topFieldTopConstraint.constant      = 8
        topFieldTrailingConstraint.constant = 0
        
        bottomFieldLeadingConstraint.constant   = 0
        bottomFieldBottomConstraint.constant    = 52
        bottomFieldTrailingConstraint.constant  = 0
        
//        showPlaceholderText()
        configureTextFields()
    }

    internal func hidePlaceholderText() {
        /** Hide unedited field if taking snapshot of view to share */
        topField.alpha      = (topText == "") ? 0 : 1
        bottomField.alpha   = (bottomText == "") ? 0 : 1
    }
    
    internal func showPlaceholderText() {
        topField.alpha      = (topText == "") ? 0.5 : 1
        bottomField.alpha   = (bottomText == "") ? 0.5 : 1
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

extension MemeEditorView: UITextFieldDelegate {
    
    internal func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        stateMachine.state.value = .IsEditingText
        
        /** 
         * For some reason defaultTextAttributes get changed if you tap into
         * the field, don't type anything, then tap 'Done' on the keyboard. This
         * fixes that scenario.
        */
        textField.defaultTextAttributes  = textFieldAttributes
        textField.textAlignment          = .Center
        textField.placeholder = nil
        textField.alpha = 1.0
        
        /** Set up observers */
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
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
        topText     = topField.text as String! ?? ""
        bottomText  = bottomField.text as String! ?? ""
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



