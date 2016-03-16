//
//  SavedMemeViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemeViewController: UIViewController {
    private var savedMemeView: SavedMemeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Configuration
    
    internal func configure(withMemeImage image: UIImage) {
        savedMemeView = view as! SavedMemeView
        savedMemeView.configure(withImage: image)
    }
    
    
    private func configureNavigationItems() {
        
    }
}
