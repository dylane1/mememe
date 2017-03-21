//
//  SavedMemeDetailNavigationItem.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemeDetailNavigationItem: UINavigationItem {
    fileprivate var shareClosure: BarButtonClosure!
    fileprivate var deleteClosure: BarButtonClosure!
    fileprivate var editMemeClosure: BarButtonClosure!
    
    //MARK: - Configuration
    
    internal func configure(
        withShareClosure share: @escaping BarButtonClosure,
        deleteClosure delete: @escaping BarButtonClosure,
        editMemeClosure edit: @escaping BarButtonClosure) {
            shareClosure    = share
            deleteClosure   = delete
            editMemeClosure = edit
            
            configureNavItems()
    }
    
    fileprivate func configureNavItems() {
        var rightItemArray  = [UIBarButtonItem]()
        
        leftItemsSupplementBackButton = true
        
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped))
        
        leftBarButtonItem = shareButton
        
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped))
        
        rightItemArray.append(deleteButton)
        
        let editMemeButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editButtonTapped))
        
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
