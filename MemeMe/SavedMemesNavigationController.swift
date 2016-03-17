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
    
    
    //MARK: - View Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAttributes()
    }

    //MARK: - Configuration
    
    internal func configure(withAddClosure add: NavbarButtonClosure) {
            addClosure = add
            
            configureNavigationItems()
    }
    
    private func configureNavigationItems() {
        addButton = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: "addButtonTapped")
        navigationBar.topItem?.rightBarButtonItem = addButton
    }
    
    
    //MARK: - Actions
    
    internal func addButtonTapped() {
        addClosure?()
    }
}
