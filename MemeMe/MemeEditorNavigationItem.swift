//
//  MemeEditorNavigationItem.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class MemeEditorNavigationItem: UINavigationItem {
    fileprivate var shareClosure: BarButtonClosure?
    fileprivate var saveClosure: BarButtonClosure?
    fileprivate var clearClosure: BarButtonClosure?
    fileprivate var cancelClosure: BarButtonClosure?
    
    fileprivate var shareButton: UIBarButtonItem?
    fileprivate var saveButton: UIBarButtonItem!
    fileprivate var clearButton: UIBarButtonItem!
    fileprivate var cancelButton: UIBarButtonItem!
    
    fileprivate var state: MemeEditorState = .noImageNoText {
        didSet {
            updateButtonsEnabled()
        }
    }
    fileprivate var stateMachine: MemeEditorStateMachine! {
        didSet {
            stateMachine.state.bindAndFire { [unowned self] in
                self.state = $0
            }
        }
    }
    
    //MARK: - Configuration
    
    internal func configure(
        withShareButtonClosure share: BarButtonClosure?,
        saveButtonClosure save: @escaping BarButtonClosure,
        clearButtonClosure clear: @escaping BarButtonClosure,
        cancelButtonClosure cancel: @escaping BarButtonClosure,
        stateMachine state: MemeEditorStateMachine) {
        
            shareClosure    = share
            saveClosure     = save
            clearClosure    = clear
            cancelClosure   = cancel
        
            configureNavigationItems()
        
            stateMachine    = state
    }
    
    fileprivate func configureNavigationItems() {
        
        var leftItemArray   = [UIBarButtonItem]()
        var rightItemArray  = [UIBarButtonItem]()
        
        /** 
         * Only add share button to new meme beging created. Already existing
         * memes can be shared from the SavedMemeDetail screen.
         */
        if shareClosure != nil {
            shareButton = UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(shareButtonTapped))
            leftItemArray.append(shareButton!)
        }
        
        saveButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.save,
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped))
        leftItemArray.append(saveButton)
        
        leftBarButtonItems = leftItemArray
        
        cancelButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped))
        rightItemArray.append(cancelButton)
        
        clearButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.clear,
            style: .plain,
            target: self,
            action: #selector(clearButtonTapped))
        rightItemArray.append(clearButton)
        
        rightBarButtonItems = rightItemArray
    }
    
    //MARK: - Actions
    
    @objc internal func shareButtonTapped() {
        shareClosure?()
    }
    
    @objc internal func saveButtonTapped() {
        saveClosure?()
    }
    
    @objc internal func clearButtonTapped() {
        clearClosure?()
    }
    
    @objc internal func cancelButtonTapped() {
        cancelClosure?()
    }
    
    fileprivate func updateButtonsEnabled() {
        switch state {
        case .noImageYesText, .yesImageNoText:
            if shareButton != nil { shareButton!.isEnabled = false }
            saveButton.isEnabled      = false
            clearButton.isEnabled     = true
        case .yesImageYesText:
            if shareButton != nil { shareButton!.isEnabled = true }
            saveButton.isEnabled      = true
            clearButton.isEnabled     = true
        default:
            if shareButton != nil { shareButton!.isEnabled = false }
            saveButton.isEnabled      = false
            clearButton.isEnabled     = false
        }
    }
}
