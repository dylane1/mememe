//
//  FontColorSelectionViewController.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/4/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class FontColorSelectionViewController: UIViewController {

    fileprivate var mainViewViewModel: MemeEditorViewModel!
    
    fileprivate var selectionView: FontColorSelectionView!
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        selectionView = view as! FontColorSelectionView
        
        let colorSelectedClosure = { [weak self] (index: Int) in
            
            self!.mainViewViewModel.fontColor.value = Constants.FontColorArray[index]
            
            /** Save selection to NSUserDefaults */
            Constants.userDefaults.set(Constants.FontColorStringArray[index] as NSString, forKey: Constants.StorageKeys.fontColor)
        }
        selectionView.configure(withCurrentColor: mainViewViewModel.fontColor.value, selectionClosure: colorSelectedClosure)
    }

    //MARK: - Configuration
    
    internal func configure(withViewModel viewModel: MemeEditorViewModel) {
        mainViewViewModel = viewModel
    }
}
