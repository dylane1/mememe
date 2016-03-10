//
//  NavigationController.swift
//  Pitch Perfect
//
//  Created by Dylan Edwards on 1/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class MemeEditorNavigationController: UINavigationController {
    /** Set by presenting view controller */
    var vcShouldBeDismissed: (() -> Void)?
    
    private var shareClosure: NavbarButtonClosure?
    private var saveClosure: NavbarButtonClosure?
    private var clearClosure: NavbarButtonClosure?
    
    private var shareButton: UIBarButtonItem!
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
    
    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAttributes()
        configureNavigationItems()
    }
    

    //MARK: - Internal funk(s)
    
    internal func configure(
        withShareButtonClosure share: NavbarButtonClosure,
        saveButtonClosure save: NavbarButtonClosure,
        clearButtonClosure clear: NavbarButtonClosure,
        stateMachine state: MemeEditorStateMachine) {
            shareClosure    = share
            saveClosure     = save
            clearClosure    = clear
            stateMachine    = state
    }
    
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
        vcShouldBeDismissed?()
    }
    
    
    //MARK: - Private funk(s)
    
    private func configureNavigationItems() {
        var leftItemArray = [UIBarButtonItem]()
        
        shareButton = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: "shareButtonTapped")
        leftItemArray.append(shareButton)
        
        saveButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.save,
            style: .Plain,
            target: self,
            action: "saveButtonTapped")
        leftItemArray.append(saveButton)
        
        navigationBar.topItem?.leftBarButtonItems = leftItemArray
        
        var rightItemArray = [UIBarButtonItem]()
        
        cancelButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.cancel,
            style: .Plain,
            target: self,
            action: "cancelButtonTapped")
        rightItemArray.append(cancelButton)
        
        clearButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.clear,
            style: .Plain,
            target: self,
            action: "clearButtonTapped")
        rightItemArray.append(clearButton)
        
        navigationBar.topItem?.rightBarButtonItems = rightItemArray
    }
    
    private func updateButtonsEnabled() {
        switch state {
        case .NoImageYesText, .YesImageNoText:
            shareButton.enabled     = false
            saveButton.enabled      = false
            clearButton.enabled     = true
        case .YesImageYesText:
            shareButton.enabled     = true
            saveButton.enabled      = true
            clearButton.enabled     = true
        default:
            shareButton.enabled     = false
            saveButton.enabled      = false
            clearButton.enabled     = false
        }
    }
}
