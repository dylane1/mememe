//
//  SavedMemesNavigationController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesNavigationController: NavigationController {

    /** Table & Collection Views */
    private var addClosure: BarButtonClosure?
    private var addButton: UIBarButtonItem?
//    private var editClosure: BarButtonClosure?
//    private var editButton: UIBarButtonItem?
    
    
    //MARK: - View Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Configuration
    
    internal func configure(withAddClosure add: BarButtonClosure) {
        addClosure = add
        
        configureNavigationItems()
    }
    
    private func configureNavigationItems() {
        addButton = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: #selector(addButtonTapped))
        navigationBar.topItem?.rightBarButtonItem = addButton
    }
    
    //MARK: - Actions
    
    internal func addButtonTapped() {
        addClosure?()
    }
}
