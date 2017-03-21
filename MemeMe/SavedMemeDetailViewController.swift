//
//  SavedMemeViewController.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemeDetailViewController: UIViewController, ActivityViewControllerPresentable, MemeEditorPresentable {
    @IBOutlet weak var navItem: SavedMemeDetailNavigationItem!
    fileprivate var savedMemeView: SavedMemeDetailView!
    
    fileprivate var storedMemesProvider: MemesProvider!
    
    /** Closures passed to navItem */
    fileprivate var shareButtonClosure: BarButtonClosure!
    fileprivate var deleteButtonClosure: BarButtonClosure!
    fileprivate var editMemeButtonClosure: BarButtonClosure!

    /** 
      Sent from TableVC or CollectionVC via SavedMemesNavigationProtocol
      extension to reset the table or collection view
    */
    fileprivate var deleteClosure: (()->Void)?
    
    /** ActivityViewControllerPresentable */
    internal var activityViewController: UIActivityViewController?
    internal var activitySuccessCompletion: (() -> Void)? = nil // No need to do anything after sharing
    
    /** Editing */
    fileprivate var meme: Meme!
    fileprivate var selectedIndex: Int!
    internal var memeEditorNavController: NavigationController?
    
    //MARK: - View Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        savedMemeView = view as! SavedMemeDetailView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /** Meme may have been changed in Editor, so load on viewWillAppear */
        storedMemesProvider = MemesProvider()
        
        meme = storedMemesProvider.memeArray[selectedIndex]
        
        savedMemeView.configure(withImage: meme.memedImage!)
    }

    //MARK: - Configuration

    internal func configure(withSelectedIndex index: Int, deletionClosure delete: @escaping BarButtonClosure) {
        selectedIndex  = index
        deleteClosure   = delete
        
        configureClosures()
        
        navItem.configure(
            withShareClosure: shareButtonClosure,
            deleteClosure: deleteButtonClosure,
            editMemeClosure: editMemeButtonClosure)
    }

    fileprivate func configureClosures() {
        shareButtonClosure = { [unowned self] in

            self.activityViewController = self.getActivityViewController(withImage: self.meme.memedImage!)
            
            self.present(self.activityViewController!, animated: true, completion: nil)
        }

        deleteButtonClosure = { [unowned self] in

            /** Open a confirmation alert */
            let alert = UIAlertController(
                title: LocalizedStrings.Alerts.DeleteMemeConfirm.title,
                message: LocalizedStrings.Alerts.DeleteMemeConfirm.message,
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.cancel, style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.ok, style: .destructive) { (alert: UIAlertAction!) in
                /** Remove meme from storage & Table or Collection view */
                self.deleteClosure?()
                
                /** Remove image from view */
                self.savedMemeView.imageView.image = nil
                
                /** Close This View Controller */
                self.navigationController?.popToRootViewController(animated: true)
            })

            self.present(alert, animated: true, completion: nil)
        }
        
        editMemeButtonClosure = { [unowned self] in
            /** MemeEditorPresentable */
            self.memeEditorNavController = self.getMemeEditorNavigationController()
            
            let editorViewController = self.memeEditorNavController!.topViewController as! MemeEditorViewController
            
            editorViewController.configure(withMeme: self.meme, atIndex: self.selectedIndex)
            
            self.present(self.memeEditorNavController!, animated: true, completion: nil)
        }
    }
}
