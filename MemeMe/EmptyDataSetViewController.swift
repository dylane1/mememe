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
    
    fileprivate func configureLabels() {
        label0.adjustsFontSizeToFitWidth = true
        label1.adjustsFontSizeToFitWidth = true
        
        let Label0Attributes = [
            NSAttributedStringKey.strokeColor.rawValue: Constants.ColorScheme.whiteAlpha90,
            NSAttributedStringKey.strokeWidth: -3.0,
            NSAttributedStringKey.foregroundColor : Constants.ColorScheme.whiteAlpha70,
            NSAttributedStringKey.font: UIFont(name: Constants.FontName.markerFelt, size: 20)! //UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        ] as! [NSAttributedStringKey : Any]
        
        let Label1Attributes = [
            NSAttributedStringKey.foregroundColor : Constants.ColorScheme.whiteAlpha70,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        ]
        
        label0.attributedText = NSAttributedString(string: LocalizedStrings.EmptyDataSetVCLabels.label0, attributes: Label0Attributes)
        label1.attributedText = NSAttributedString(string: LocalizedStrings.EmptyDataSetVCLabels.label1, attributes: Label1Attributes)
    }

}
