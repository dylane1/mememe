//
//  SavedMemeViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemeDetailViewController: UIViewController, ActivityViewControllerPresentable, MemeEditorPresentable {
    @IBOutlet weak var navItem: SavedMemeDetailNavigationItem!
    private var shareClosure: BarButtonClosure!
    private var deleteClosure: BarButtonClosure!
    private var editMemeClosure: BarButtonClosure!
    
    private var savedMemeView: SavedMemeDetailView!
    
    /** ShareActivityOpenable */
    internal var imageToShare = UIImage()
    internal var activityViewControllerCompletion: UIActivityViewControllerCompletionWithItemsHandler = { activityType, completed, returnedItems, activityError in
        if !completed {
        //TODO: pop alert
        fatalError(LocalizedStrings.ErrorAlerts.ShareError.message)
        
        } else {
        /** Success! */
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        configureClosures()
        navItem.configure(
            withShareClosure: shareClosure,
            deleteClosure: deleteClosure,
            editMemeClosure: editMemeClosure)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Configuration
    //TODO: add deleteClosure
    //TODO: needs to be called again when coming back from edit
    internal func configure(withMeme meme: Meme) {
        savedMemeView = view as! SavedMemeDetailView
        savedMemeView.configure(withImage: meme.memedImage!)
        imageToShare = meme.memedImage!
    }
    
    
    //TODO: Probable want to make a MemeSharable protocol that this & MemeEditor conform to
    
    private func configureClosures() {
        shareClosure = {
            self.presentViewController(self.activityViewController, animated: true, completion: nil)
        }
        
        deleteClosure = {
            
            /** 
            
            */
            magic("Delete!")
        }
        
        editMemeClosure = { [weak self] in
            self!.presentViewController(self!.memeEditorNavController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions

}
