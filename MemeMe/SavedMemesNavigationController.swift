//
//  SavedMemesNavigationController.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesNavigationController: NavigationController {

    fileprivate var addClosure: BarButtonClosure?
    fileprivate var addButton: UIBarButtonItem?
    
    fileprivate var emptyDataSetVC: EmptyDataSetViewController?

    //MARK: - Configuration
    
    internal func configure(withAddClosure add: @escaping BarButtonClosure) {
        addClosure = add
        
        configureNavigationItems()
    }
    
    fileprivate func configureNavigationItems() {
        addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped))
        navigationBar.topItem?.rightBarButtonItem = addButton
    }
    
    //MARK: - Actions
    
    @objc internal func addButtonTapped() {
        addClosure?()
    }
}
