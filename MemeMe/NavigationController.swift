//
//  NavigationController.swift
//  Pitch Perfect
//
//  Created by Dylan Edwards on 1/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

//protocol NavigationControllerDataSource {
//    var shareButtonEnabled: Dynamic<Bool> { get }
//    var cancelButtonEnabled: Dynamic<Bool> { get }
//}

class NavigationController: UINavigationController {
    typealias NavbarButtonClosure = () -> Void
    private var shareClosure: NavbarButtonClosure?
    private var cancelClosure: NavbarButtonClosure?
    
    private var shareButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!
    
    private var state: AppState = .NoImageNoText {
        didSet {
            updateButtonsEnabled()
        }
    }
    private var stateMachine: StateMachine! {
        didSet {
            stateMachine.state.bindAndFire { [unowned self] in
                self.state = $0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItems()
        //TODO: get colors right: http://b2cloud.com.au/how-to-guides/bar-color-calculator-for-ios7-and-ios8/
//        navigationBar.barTintColor = GTColor.mediumGrey
//        navigationBar.tintColor    = GTColor.orange
        navigationBar.translucent  = true

        let titleLabelAttributes = [
            NSForegroundColorAttributeName : Constants.ColorScheme.blue,
            NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        ]
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
    
    
    //MARK: - Public funk(s)
    
    func configure(withShareButtonClosure share: NavbarButtonClosure, cancelButtonClosure cancel: NavbarButtonClosure, stateMachine state: StateMachine){
        shareClosure    = share
        cancelClosure   = cancel
        stateMachine    = state
    }
    
    func shareButtonTapped() {
        shareClosure?()
    }
    
    func cancelButtonTapped() {
        cancelClosure?()
    }
    
    
    //MARK: - Private funk(s)
    
    private func configureNavigationItems() {
        
        shareButton = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: "shareButtonTapped")
        navigationBar.topItem?.leftBarButtonItem = shareButton
        
        cancelButton = UIBarButtonItem(
            title: LocalizedStrings.NavigationControllerButtons.cancel,
            style: .Plain,
            target: self,
            action: "cancelButtonTapped")
        navigationBar.topItem?.rightBarButtonItem = cancelButton
    }
    
    private func updateButtonsEnabled() {
        switch state {
        case .NoImageYesText, .YesImageNoText:
            shareButton.enabled     = false
            cancelButton.enabled    = true
        case .YesImageYesText:
            shareButton.enabled     = true
            cancelButton.enabled    = true
        default:
            shareButton.enabled     = false
            cancelButton.enabled    = false
        }
    }
}







