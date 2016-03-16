//
//  SavedMemesNavigationController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemesNavigationController: UINavigationController {

    /** Table & Collection Views */
    private var addClosure: NavbarButtonClosure?
    private var addButton: UIBarButtonItem?
//    private var editClosure: NavbarButtonClosure?
//    private var editButton: UIBarButtonItem?
    
    /** Detail View */
    private var editMemeClosure: NavbarButtonClosure?
    
    //MARK: - View Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAttributes()
    }

    internal func configure(withAddButtonClosure add: NavbarButtonClosure?){
        addClosure = add
        
        configureNavigationItems()
    }
    
    internal func addButtonTapped() {
        addClosure?()
    }
    
    private func configureNavigationItems() {
        var leftItemArray   = [UIBarButtonItem]()
        var rightItemArray  = [UIBarButtonItem]()
        
        /** Table, Collection, & detail Views */
//        if editClosure != nil || editMemeClosure != nil {
//            let action = (editClosure != nil) ? "editButtonTapped" : "editMemeButtonTapped"
//            editButton = UIBarButtonItem(
//                title: LocalizedStrings.NavigationControllerButtons.edit,
//                style: .Plain,
//                target: self,
//                action: action)
//        }
        
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
