//
//  SavedMemeView.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/10/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemeDetailView: UIView {

    fileprivate var image: UIImage? = nil {
        didSet {
            /** Set image in imageView */
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!


    internal func configure(withImage image: UIImage) {
        self.image = image
        imageView.backgroundColor = Constants.ColorScheme.darkGrey
    }
}
