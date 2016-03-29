//
//  SavedMemeViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemeDetailViewController: UIViewController, ActivityViewControllerPresentable, MemeEditorPresentable {
    @IBOutlet weak var navItem: SavedMemeDetailNavigationItem!
    private var savedMemeView: SavedMemeDetailView!
    
    private var storedMemesProvider: MemesProvider!
    
    /** Closures passed to navItem */
    private var shareButtonClosure: BarButtonClosure!
    private var deleteButtonClosure: BarButtonClosure!
    private var editMemeButtonClosure: BarButtonClosure!
    
    //TODO: Comment where everything is being sent from in all the files! 
    /** 
      Sent from TableVC or CollectionVC via SavedMemesNavigationProtocol
      extension to reset the table or collection view
    */
    private var deleteClosure: (()->Void)?
    
    /** ActivityViewControllerPresentable */
    internal var activityViewController: UIActivityViewController?
    internal var activitySuccessCompletion: (() -> Void)? = nil // No need to do anything after sharing
    
    /** Editing */
    private var meme: Meme!
    private var selectedIndex: Int!
    internal var memeEditorNavController: NavigationController?
    
    //MARK: - View Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedMemeView = view as! SavedMemeDetailView
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /** Meme may have been changed in Editor, so load on viewWillAppear */
        storedMemesProvider = MemesProvider()
        
        meme = storedMemesProvider.memeArray[selectedIndex]
        
        savedMemeView.configure(withImage: meme.memedImage!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Configuration

    internal func configure(withSelectedIndex index: Int, deletionClosure delete: BarButtonClosure) {
        selectedIndex  = index
        deleteClosure   = delete
        
        configureClosures()
        
        navItem.configure(
            withShareClosure: shareButtonClosure,
            deleteClosure: deleteButtonClosure,
            editMemeClosure: editMemeButtonClosure)
    }

    private func configureClosures() {
        shareButtonClosure = { [unowned self] in

            self.activityViewController = self.getActivityViewController(withImage: self.meme.memedImage!)
            
            self.presentViewController(self.activityViewController!, animated: true, completion: nil)
        }

        deleteButtonClosure = { [unowned self] in

            /** Open a confirmation alert */
            let alert = UIAlertController(
                title: LocalizedStrings.Alerts.DeleteMemeConfirm.title,
                message: LocalizedStrings.Alerts.DeleteMemeConfirm.message,
                preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.cancel, style: .Cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.ok, style: .Destructive) { (alert: UIAlertAction!) in
                /** Remove meme from storage & Table or Collection view */
                self.deleteClosure?()
                
                /** Remove image from view */
                self.savedMemeView.imageView.image = nil
                
                /** Close This View Controller */
                self.navigationController?.popToRootViewControllerAnimated(true)
            })

            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        editMemeButtonClosure = { [unowned self] in
            /** MemeEditorPresentable */
            self.memeEditorNavController = self.getMemeEditorNavigationController()
            
            let editorViewController = self.memeEditorNavController!.topViewController as! MemeEditorViewController
            
            editorViewController.configure(withMeme: self.meme, atIndex: self.selectedIndex)
            
            self.presentViewController(self.memeEditorNavController!, animated: true, completion: nil)
        }
    }
}
