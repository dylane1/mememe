//
//  SavedMemesNavigationController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemesNavigationController: UINavigationController {

    private var addClosure: NavbarButtonClosure?
    
    private var addButton: UIBarButtonItem?
    
    
    //MARK: - View Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAttributes()
    }

    internal func configure(withAddButtonClosure add: NavbarButtonClosure?){
        magic("")
        addClosure = add
        
        configureNavigationItems()
    }
    
    internal func addButtonTapped() {
        addClosure?()
    }
    
    private func configureNavigationItems() {
        magic("")
        if addClosure != nil {
            addButton = UIBarButtonItem(
                barButtonSystemItem: .Add,
                target: self,
                action: "addButtonTapped")
            navigationBar.topItem?.rightBarButtonItem = addButton
        }
        
        
//        cancelButton = UIBarButtonItem(
//            title: LocalizedStrings.NavigationControllerButtons.cancel,
//            style: .Plain,
//            target: self,
//            action: "cancelButtonTapped")
//        navigationBar.topItem?.rightBarButtonItem = cancelButton
    }
    
//    private func updateButtonsEnabled() {
//        switch state {
//        case .NoImageYesText, .YesImageNoText:
//            shareButton.enabled     = false
//            cancelButton.enabled    = true
//        case .YesImageYesText:
//            shareButton.enabled     = true
//            cancelButton.enabled    = true
//        default:
//            shareButton.enabled     = false
//            cancelButton.enabled    = false
//        }
//    }
}
