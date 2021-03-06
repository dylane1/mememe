//
//  MainView.swift
//  MemeMeister
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
    fileprivate var albumButtonClosure: BarButtonClosure?
    fileprivate var cameraButtonClosure: BarButtonClosure?
    
    fileprivate var fontButtonClosure: BarButtonClosureWithButtonItemSource?
    fileprivate var fontButton: UIBarButtonItem!
    fileprivate var fontColorButtonClosure: BarButtonClosureWithButtonItemSource?
    fileprivate var fontColorButton: UIBarButtonItem!
    
    typealias MemeTextUpdated = (String, String) -> Void
    fileprivate var memeTextUpdatedClosure: MemeTextUpdated?
    
    typealias MemeImageUpdated = (UIImage?) -> Void
    fileprivate var memeImageUpdatedClosure: MemeImageUpdated?
    
    typealias MemeFontUpdated = (UIFont) -> Void
    fileprivate var memeFontUpdatedClosure: MemeFontUpdated?
    
    typealias MemeFontColorUpdated = (UIColor) -> Void
    fileprivate var memeFontColorUpdatedClosure: MemeFontColorUpdated?
    
    fileprivate var image: UIImage? = nil {
        didSet {
            /** Set image in imageView */
            imageView.image = image
            
            /** 
             Update text field constraints for new image at current orientation 
             */
            let orientation: DestinationOrientation
            if UIDevice.current.orientation.isLandscape {
                orientation = .landscape
            } else {
                orientation = .portrait
            }
            updateTextFieldContstraints(withNewOrientation: orientation)
            
            memeImageUpdatedClosure?(image)
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    
    fileprivate var topText = "" {
        didSet {
            if topText != "" {
                prepareTextFieldForAttributedText(topField)
            }
            
            topField.text = topText
            
            memeTextUpdatedClosure?(topText, bottomText)
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    fileprivate var bottomText = "" {
        didSet {
            if bottomText != "" {
                prepareTextFieldForAttributedText(bottomField)
            }
            
            bottomField.text = bottomText
            
            memeTextUpdatedClosure?(topText, bottomText)
            stateMachine.changeState(withImage: image, topText: topText, bottomText: bottomText)
        }
    }
    
    fileprivate var font: UIFont = Constants.Font.impact {
        didSet {
            memeFontUpdatedClosure?(font)
            
            /** Update text field fonts */
            configureTextFieldAttributes()
        }
    }
    
    fileprivate var fontColor: UIColor = Constants.ColorScheme.white {
        didSet {
            memeFontColorUpdatedClosure?(fontColor)
            
            /** Update text field fonts */
            configureTextFieldAttributes()
        }
    }
    
//    fileprivate var textFieldAttributes: [NSAttributedStringKey : Any] = [
    fileprivate var textFieldAttributes: [String : Any] = [
        NSAttributedStringKey.strokeColor.rawValue:     Constants.ColorScheme.black,
        NSAttributedStringKey.strokeWidth.rawValue:     -5.0
    ]
    
    fileprivate var dataSource: MemeEditorViewModel! {
        didSet {
            dataSource.image.bind { [unowned self] in
                self.image = $0
            }
            dataSource.topText.bind { [unowned self] in
                self.topText = $0
            }
            dataSource.bottomText.bind { [unowned self] in
                self.bottomText = $0
            }
            /** 
             * Using bindAndFire for these because the font & fontColor are
             * loaded from NSUserDefaults and passed when view is configured.
             */
            dataSource.font.bindAndFire { [unowned self] in
                self.font = $0
            }
            dataSource.fontColor.bindAndFire { [unowned self] in
                self.fontColor = $0
            }
        }
    }
    
    fileprivate var stateMachine: MemeEditorStateMachine!
    
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
    
    
    //MARK: - Configuration
    
    internal func configure(
        withStateMachine stateMachine: MemeEditorStateMachine,
        dataSource: MemeEditorViewModel,
        albumButtonClosure: @escaping BarButtonClosure,
        cameraButtonClosure: BarButtonClosure? = nil,
        fontButtonClosure: @escaping BarButtonClosureWithButtonItemSource,
        fontColorButtonClosure: @escaping BarButtonClosureWithButtonItemSource,
        memeImageUpdatedClosure: @escaping MemeImageUpdated,
        memeTextUpdatedClosure: @escaping MemeTextUpdated,
        memeFontUpdatedClosure: @escaping MemeFontUpdated,
        memeFontColorUpdatedClosure: @escaping MemeFontColorUpdated) {
        
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
        
        imageView.backgroundColor = Constants.ColorScheme.darkGrey
        configureToolbarItems()
        configureTextFields()
    }

    fileprivate func configureToolbarItems() {
        
        var toolbarItemArray = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbarItemArray.append(flexSpace)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20
        
        let cameraButton = UIBarButtonItem(
            barButtonSystemItem: .camera,
            target: self,
            action: #selector(cameraButtonTapped))
        
        cameraButton.isEnabled = false
        
        toolbarItemArray.append(cameraButton)
        toolbarItemArray.append(fixedSpace)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) { cameraButton.isEnabled = true }
        
        let albumButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.album,
            style: .plain,
            target: self,
            action: #selector(albumButtonTapped))
        
        toolbarItemArray.append(albumButton)
        toolbarItemArray.append(fixedSpace)
        
        fontButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.font,
            style: .plain,
            target: self,
            action: #selector(fontButtonTapped))
        
        toolbarItemArray.append(fontButton)
        toolbarItemArray.append(fixedSpace)
        
        fontColorButton = UIBarButtonItem(
            title: LocalizedStrings.ToolbarButtons.color,
            style: .plain,
            target: self,
            action: #selector(fontColorButtonTapped))
        
        toolbarItemArray.append(fontColorButton)
        toolbarItemArray.append(flexSpace)
        
        toolbar.setItems(toolbarItemArray, animated: false)
        
        toolbar.barTintColor = Constants.ColorScheme.darkBlue
        toolbar.tintColor    = Constants.ColorScheme.white
        toolbar.isTranslucent  = true
    }
    
    fileprivate func configureTextFields() {
        topField.delegate                   = self
        topField.borderStyle                = .none
        topField.backgroundColor            = UIColor.clear
        topField.returnKeyType              = .done
        topField.autocapitalizationType     = .allCharacters
        topField.adjustsFontSizeToFitWidth  = true
        
        bottomField.delegate                    = self
        bottomField.borderStyle                 = .none
        bottomField.backgroundColor             = UIColor.clear
        bottomField.returnKeyType               = .done
        bottomField.autocapitalizationType      = .allCharacters
        bottomField.adjustsFontSizeToFitWidth   = true
        
        configureTextFieldAttributes()
        showPlaceholderText()
    }
    
    internal func configureTextFieldAttributes() {
        
        textFieldAttributes[NSAttributedStringKey.font.rawValue] = font
        textFieldAttributes[NSAttributedStringKey.foregroundColor.rawValue] = fontColor
        
        let placeholderAttributes: [NSAttributedStringKey : Any] = [
//        let placeholderAttributes: [String : Any] = [
            NSAttributedStringKey.foregroundColor: fontColor,
            NSAttributedStringKey.font:            font
//            NSAttributedStringKey.foregroundColor.rawValue: fontColor,
//            NSAttributedStringKey.font.rawValue:            font
        ]
        
        topField.defaultTextAttributes  = textFieldAttributes
        topField.attributedPlaceholder  = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.top, attributes: placeholderAttributes)
        topField.textAlignment          = .center //Must be set after the string is set in order to work...
        
        bottomField.defaultTextAttributes   = textFieldAttributes
        bottomField.attributedPlaceholder   = NSAttributedString(string: LocalizedStrings.PlaceholderText.MainView.bottom, attributes: placeholderAttributes)
        bottomField.textAlignment           = .center
    }
    
    
    //MARK: - Actions
    
    @objc internal func cameraButtonTapped() {
        cameraButtonClosure?()
    }
    
    @objc internal func albumButtonTapped() {
        albumButtonClosure?()
    }
    
    @objc internal func fontButtonTapped() {
        fontButtonClosure?(fontButton)
    }
    
    @objc internal func fontColorButtonTapped() {
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
    

    fileprivate func prepareTextFieldForAttributedText(_ textField: UITextField) {
        textField.defaultTextAttributes  = textFieldAttributes
        textField.textAlignment          = .center
        textField.placeholder = nil
        textField.alpha = 1.0
    }
    
    
    internal func updateTextFieldContstraints(withNewOrientation orientation: DestinationOrientation) {
        /** Close keyboard on rotation */
        if bottomField.isFirstResponder {
            bottomField.resignFirstResponder()
        }

        if imageView.image == nil { return }

        if orientation == .landscape {
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
            
            var newConstant = ((imageView.frame.height - correctHeight) / 2)
            newConstant = (newConstant > 0) ? newConstant : 0 // Negative number is bad, very bad...
            
            topFieldTopConstraint.constant          = newConstant + 8
            bottomFieldBottomConstraint.constant    = newConstant + 52
        }
    }
    
    internal func getInfoForImageContext() -> (size: CGSize, x: CGFloat, y: CGFloat) {
        let multiplier: CGFloat
        
        if UIDevice.current.orientation.isLandscape {
            /** Landscape: height is constricted */
            multiplier = imageView.frame.height / imageView.image!.size.height
        } else {
            /** Portrait: width is constricted */
            multiplier = imageView.frame.width / imageView.image!.size.width
        }
        
        var width = imageView.image!.size.width * multiplier
        var height = imageView.image!.size.height * multiplier
        
        
        let x: CGFloat
        if width >= imageView.frame.width {
            width = imageView.frame.width
            x = 0
        } else {
            x = (imageView.frame.width - width) / 2
        }
        
        let y: CGFloat
        if height >= imageView.frame.height {
            height = imageView.frame.height
            y = 0
        } else {
            y = (imageView.frame.height - height) / 2
        }
        
        return (size: CGSize(width: width, height: height), x: x, y: y)
    }
}


//MARK: - UITextFieldDelegate
extension MemeEditorView: UITextFieldDelegate {
    
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        stateMachine.state.value = .isEditingText
        
        /** 
         * For some reason defaultTextAttributes get changed if you tap into
         * the field, don't type anything, then tap 'Done' on the keyboard. This
         * fixes that scenario.
        */
        prepareTextFieldForAttributedText(textField)
        
        /** Set up observers */
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)

        return true
    }
    
    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        topText     = topField.text as String? ?? ""
        bottomText  = bottomField.text as String? ?? ""
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //TODO: this isn't a delegate method
    @objc internal func keyboardWillShow(_ notification: Notification) {
        /** Animate the view up so bottom text field is visible while editing */
        if bottomField.isEditing {
            let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size
            
            UIView.animate(withDuration: 0.5, animations: {
                var frame       = self.frame
                frame.origin.y  = -(keyboardSize.height) + self.toolbar!.frame.height
                self.frame      = frame
            }) 
        }
    }
    //TODO: this isn't a delegate method
    @objc internal func keyboardWillHide(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        /** Animate view back down if done editing the bottom text field */
        if bottomField.isEditing {
            UIView.animate(withDuration: 0.5, animations: {
                var frame       = self.frame
                frame.origin.y  = 0.0
                self.frame      = frame
            }) 
        }
    }
}
