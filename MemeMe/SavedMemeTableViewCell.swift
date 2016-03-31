//
//  SavedMemesTableViewCell.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesTableViewCell: UITableViewCell {
    @IBOutlet private weak var memeLabel: UILabel!
    @IBOutlet private weak var memeImageView: UIImageView!
    
    private var dataSource: SavedMemeCellDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func configure(withDataSource dataSource: SavedMemeCellDataSource) {
        self.dataSource = dataSource
        configureImageView()
        configureLabel()
        configureCell()
    }
    
    private func configureImageView() {
        memeImageView.backgroundColor = Constants.ColorScheme.darkGrey
        memeImageView.image = dataSource.meme.memedImage
    }
    
    private func configureLabel() {
        memeLabel.adjustsFontSizeToFitWidth  = true
        
        var attributes = dataSource.textAttributes
        attributes[NSFontAttributeName] = dataSource.meme.font
        
        let topText = dataSource.meme.topText
        let bottomText = dataSource.meme.bottomText
        
        var title = topText
        if topText != "" && bottomText != "" { title += "\n\n" }
        title += bottomText
        
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)

        memeLabel.attributedText = attributedString
    }
    
    private func configureCell() {
        backgroundColor = Constants.ColorScheme.whiteAlpha50
    }
}
