//
//  EmptyDataSetViewController.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/29/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class EmptyDataSetViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label0: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
    }

    //MARK: - Configuration
    
    private func configureLabels() {
        label0.adjustsFontSizeToFitWidth = true
        label1.adjustsFontSizeToFitWidth = true
        
        let Label0Attributes = [
            NSStrokeColorAttributeName: Constants.ColorScheme.whiteAlpha90,
            NSStrokeWidthAttributeName: -3.0,
            NSForegroundColorAttributeName : Constants.ColorScheme.whiteAlpha70,
            NSFontAttributeName: UIFont(name: Constants.FontName.markerFelt, size: 20)! //UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        ]
        
        let Label1Attributes = [
            NSForegroundColorAttributeName : Constants.ColorScheme.whiteAlpha70,
            NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        ]
        
        label0.attributedText = NSAttributedString(string: LocalizedStrings.EmptyDataSetVCLabels.label0, attributes: Label0Attributes)
        label1.attributedText = NSAttributedString(string: LocalizedStrings.EmptyDataSetVCLabels.label1, attributes: Label1Attributes)
    }

}
