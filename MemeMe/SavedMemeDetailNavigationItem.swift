//
//  SavedMemeDetailNavigationItem.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemeDetailNavigationItem: UINavigationItem {
    private var shareClosure: BarButtonClosure!
    private var deleteClosure: BarButtonClosure!
    private var editMemeClosure: BarButtonClosure!
    //MARK: - Configuration
    
    internal func configure(
        withShareClosure share: BarButtonClosure,
        deleteClosure delete: BarButtonClosure,
        editMemeClosure edit: BarButtonClosure) {
            shareClosure    = share
            deleteClosure   = delete
            editMemeClosure = edit
            
            configureNavItems()
    }
    
    private func configureNavItems() {
        var rightItemArray  = [UIBarButtonItem]()
        
        leftItemsSupplementBackButton = true
        
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: "shareButtonTapped")
        
        leftBarButtonItem = shareButton
        
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .Trash,
            target: self,
            action: "deleteButtonTapped")
        
        rightItemArray.append(deleteButton)
        
        let editMemeButton = UIBarButtonItem(
            barButtonSystemItem: .Edit,
            target: self,
            action: "editButtonTapped")
        
        rightItemArray.append(editMemeButton)
        
        rightBarButtonItems = rightItemArray
    }
    

    
    //MARK: - Actions
    
    internal func shareButtonTapped() {
        shareClosure?()
    }
    internal func deleteButtonTapped() {
        deleteClosure?()
    }
    internal func editButtonTapped() {
        editMemeClosure?()
    }
}
