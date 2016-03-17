//
//  SavedMemeView.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/10/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemeDetailView: UIView {

    private var image: UIImage? = nil {
        didSet {
            /** Set image in imageView */
            imageView.image = image
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    internal func configure(withImage image: UIImage) {
        self.image = image
    }
}
