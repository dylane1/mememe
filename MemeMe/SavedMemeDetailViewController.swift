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
    private var savedMemeView: SavedMemeDetailView!
    
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
    internal var imageToShare = UIImage()
    internal var activitySuccessCompletion: (() -> Void)? = nil //no need to do anything after sharing
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Configuration

    //TODO: memedImage/imageToShare need to be changed when coming back from edit
    internal func configure(withMeme meme: Meme, deletionClosure delete: BarButtonClosure) {
        savedMemeView = view as! SavedMemeDetailView
        savedMemeView.configure(withImage: meme.memedImage!)
        
        deleteClosure   = delete
        imageToShare    = meme.memedImage!
        
        configureClosures()
        navItem.configure(
            withShareClosure: shareButtonClosure,
            deleteClosure: deleteButtonClosure,
            editMemeClosure: editMemeButtonClosure)
    }


    private func configureClosures() {
        shareButtonClosure = {
            self.presentViewController(self.activityViewController, animated: true, completion: nil)
        }

        deleteButtonClosure = {

            /** Open a confirmation alert */
            let alert = UIAlertController(
                title: LocalizedStrings.Alerts.DeleteMemeConfirm.title,
                message: LocalizedStrings.Alerts.DeleteMemeConfirm.message,
                preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.ok, style: .Destructive) { (alert: UIAlertAction!) in
                /** Remove meme from storage & Table or Collection view */
                self.deleteClosure?()
                
                /** Remove image from view */
                self.savedMemeView.imageView.image = nil
                
                /** Close This View Controller */
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.cancel, style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
        editMemeButtonClosure = { [weak self] in
            self!.presentViewController(self!.memeEditorNavController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions

}
