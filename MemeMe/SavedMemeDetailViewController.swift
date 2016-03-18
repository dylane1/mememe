//
//  SavedMemeViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemeDetailViewController: UIViewController, MemeEditorOpenable {
    @IBOutlet weak var navItem: UINavigationItem!

    private var savedMemeView: SavedMemeDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        configureNavItems()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Configuration
    
    internal func configure(withMeme meme: Meme) {
        savedMemeView = view as! SavedMemeDetailView
        savedMemeView.configure(withImage: meme.memedImage!)
    }
    
    private func configureNavItems() {
        var rightItemArray  = [UIBarButtonItem]()

        navItem.leftItemsSupplementBackButton = true
        
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: "shareButtonTapped")

        navItem.leftBarButtonItem = shareButton
        
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
        
        navItem.rightBarButtonItems = rightItemArray
    }
 
    
    //TODO: Probable want to make a MemeSharable protocol that this & MemeEditor conform to 
    
    
    //MARK: - Actions

    internal func shareButtonTapped() {
//        shareClosure?()
    }
    internal func deleteButtonTapped() {
//        deleteClosure?()
    }
    internal func editButtonTapped() {
//        editMemeClosure?()
    }
}
