//
//  MemeEditorNavigationItem.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class MemeEditorNavigationItem: UINavigationItem {
    private var shareClosure: BarButtonClosure?
    private var saveClosure: BarButtonClosure?
    private var clearClosure: BarButtonClosure?
    private var cancelClosure: BarButtonClosure?
    
    private var shareButton: UIBarButtonItem?
    private var saveButton: UIBarButtonItem!
    private var clearButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!
    
    private var state: MemeEditorState = .NoImageNoText {
        didSet {
            updateButtonsEnabled()
        }
    }
    private var stateMachine: MemeEditorStateMachine! {
        didSet {
            stateMachine.state.bindAndFire { [unowned self] in
                self.state = $0
            }
        }
    }
    
    //MARK: - Configuration
    
    internal func configure(
        withShareButtonClosure share: BarButtonClosure?,
        saveButtonClosure save: BarButtonClosure,
        clearButtonClosure clear: BarButtonClosure,
        cancelButtonClosure cancel: BarButtonClosure,
        stateMachine state: MemeEditorStateMachine) {
        
            shareClosure    = share
            saveClosure     = save
            clearClosure    = clear
            cancelClosure   = cancel
        
            configureNavigationItems()
        
            stateMachine    = state
    }
    
    private func configureNavigationItems() {
        
        var leftItemArray   = [UIBarButtonItem]()
        var rightItemArray  = [UIBarButtonItem]()
        
        /** 
         * Only add share button to new meme beging created. Already existing
         * memes can be shared from the SavedMemeDetail screen.
         */
        if shareClosure != nil {
            shareButton = UIBarButtonItem(
                barButtonSystemItem: .Action,
                target: self,
                action: #selector(shareButtonTapped))
            leftItemArray.append(shareButton!)
        }
        
        saveButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.save,
            style: .Plain,
            target: self,
            action: #selector(saveButtonTapped))
        leftItemArray.append(saveButton)
        
        leftBarButtonItems = leftItemArray
        
        cancelButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.cancel,
            style: .Plain,
            target: self,
            action: #selector(cancelButtonTapped))
        rightItemArray.append(cancelButton)
        
        clearButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.clear,
            style: .Plain,
            target: self,
            action: #selector(clearButtonTapped))
        rightItemArray.append(clearButton)
        
        rightBarButtonItems = rightItemArray
    }
    
    //MARK: - Actions
    
    internal func shareButtonTapped() {
        shareClosure?()
    }
    
    internal func saveButtonTapped() {
        saveClosure?()
    }
    
    internal func clearButtonTapped() {
        clearClosure?()
    }
    
    internal func cancelButtonTapped() {
        cancelClosure?()
    }
    
    private func updateButtonsEnabled() {
        switch state {
        case .NoImageYesText, .YesImageNoText:
            if shareButton != nil { shareButton!.enabled = false }
            saveButton.enabled      = false
            clearButton.enabled     = true
        case .YesImageYesText:
            if shareButton != nil { shareButton!.enabled = true }
            saveButton.enabled      = true
            clearButton.enabled     = true
        default:
            if shareButton != nil { shareButton!.enabled = false }
            saveButton.enabled      = false
            clearButton.enabled     = false
        }
    }
}
