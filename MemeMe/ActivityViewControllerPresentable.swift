//
//  ShareActivityOpenable.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ActivityViewControllerPresentable {
    
    /** Implemented by View Controllers that conform to this protocol */
    var activitySuccessCompletion: (() -> Void)? { get set }
    var activityViewController: UIActivityViewController? { get set }
    
    /** Implemented in the protocol extension */
    var activityViewControllerCompletion: UIActivityViewControllerCompletionWithItemsHandler { get }
}

extension ActivityViewControllerPresentable where Self: UIViewController {
    
    /** Completion handler for the Activity View Controller */
    var activityViewControllerCompletion: UIActivityViewControllerCompletionWithItemsHandler {
        
        return { [weak self] activityType, completed, returnedItems, activityError in
            
            if !completed && activityError != nil {
                
                /** Activity Failed, present an alert to user */
                let alert = UIAlertController(
                    title: LocalizedStrings.Alerts.ShareError.title,
                    message: LocalizedStrings.Alerts.ShareError.message + activityError!.localizedDescription,
                    preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.ok, style: .Default, handler: nil))
                
                self!.presentViewController(alert, animated: true, completion: nil)
            } else {
                /** Success! */
                self!.activitySuccessCompletion?()
            }
            self!.activityViewController = nil
        }
    }
    
    internal func getActivityViewController(withImage image: UIImage) -> UIActivityViewController {

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        /** Set completion handler for Share */
        activityViewController.completionWithItemsHandler = activityViewControllerCompletion
        
        return activityViewController
    }
}
