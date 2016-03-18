//
//  ShareActivityOpenable.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ActivityViewControllerPresentable {
    var imageToShare: UIImage { get set }
    var activityViewController: UIActivityViewController { get }
    var activityViewControllerCompletion: UIActivityViewControllerCompletionWithItemsHandler { get set }
}

extension ActivityViewControllerPresentable where Self: UIViewController {
    var activityViewController: UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        /** Set completion handler for Share */
        activityVC.completionWithItemsHandler = activityViewControllerCompletion
        return activityVC
    }
}
