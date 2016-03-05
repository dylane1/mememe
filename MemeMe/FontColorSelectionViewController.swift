//
//  FontColorSelectionViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/4/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class FontColorSelectionViewController: UIViewController {

    private var mainViewViewModel: MainViewViewModel!
    
    private var selectionView: FontColorSelectionView!
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.ColorScheme.lightGrey
        
        selectionView = view as! FontColorSelectionView
        
        let colorSelectedClosure = { [weak self] (index: Int) in
            self!.mainViewViewModel.fontColor.value = Constants.FontColorArray[index]
            
            /** Save selection to NSUserDefaults */
            Constants.userDefaults.setObject(Constants.FontColorStringArray[index] as NSString, forKey: Constants.StorageKeys.fontColor)
        }
        
        selectionView.configure(withSelectionClosure: colorSelectedClosure)
    }

    //MARK: - Internal funk(s)
    
    internal func configure(withViewModel viewModel: MainViewViewModel) {
        mainViewViewModel = viewModel
    }

}
