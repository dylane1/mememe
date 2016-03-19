//
//  ShareActivityOpenable.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ActivityViewControllerPresentable {
    /** Implemented by View Controllers that conform to this protocol */
    var imageToShare: UIImage { get set }
    var activitySuccessCompletion: (() -> Void)? { get set }
    
    /** Implemented in the protocol extension */
    var activityViewController: UIActivityViewController { get }
    var activityViewControllerCompletion: UIActivityViewControllerCompletionWithItemsHandler { get }
}

extension ActivityViewControllerPresentable where Self: UIViewController {
    var activityViewControllerCompletion: UIActivityViewControllerCompletionWithItemsHandler {
        return { activityType, completed, returnedItems, activityError in
            if !completed && activityError != nil {
                /** Activity Failed */
                let alert = UIAlertController(
                    title: LocalizedStrings.Alerts.ShareError.title,
                    message: LocalizedStrings.Alerts.ShareError.message + activityError!.localizedDescription,
                    preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: LocalizedStrings.ButtonTitles.ok, style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                /** Success! */
                self.activitySuccessCompletion?()
            }
        }
    }
    
    var activityViewController: UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        /** Set completion handler for Share */
        activityVC.completionWithItemsHandler = activityViewControllerCompletion
        return activityVC
    }
}
