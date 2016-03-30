//
//  SavedMemesNavigationController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesNavigationController: NavigationController {

    private var addClosure: BarButtonClosure?
    private var addButton: UIBarButtonItem?
    
    private var emptyDataSetVC: EmptyDataSetViewController?
    
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
    
//    internal func insertEmptyDataSetView() {
//        emptyDataSetVC = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.emptyDataSetVC) as! EmptyDataSetViewController
//        emptyDataSetVC!.view.bounds = view.bounds
//        view.addSubview(emptyDataSetVC!.view)
//    }
    
//    internal func removeEmptyDataSetView() {
//        if emptyDataSetVC == nil { return }
//        
//        view.willRemoveSubview(<#T##subview: UIView##UIView#>)
//    }
}
