//
//  SavedMemesTableViewCell.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesTableViewCell: UITableViewCell {
    @IBOutlet fileprivate weak var memeLabel: UILabel!
    @IBOutlet fileprivate weak var memeImageView: UIImageView!
    
    fileprivate var dataSource: SavedMemeCellDataSource!
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Configuration

    internal func configure(withDataSource dataSource: SavedMemeCellDataSource) {
        self.dataSource = dataSource
        configureImageView()
        configureLabel()
        configureCell()
    }
    
    fileprivate func configureImageView() {
        memeImageView.backgroundColor = Constants.ColorScheme.darkGrey
        memeImageView.image = dataSource.meme.memedImage
    }
    
    fileprivate func configureLabel() {
        memeLabel.adjustsFontSizeToFitWidth  = true
        
        var attributes = dataSource.textAttributes
        attributes[NSAttributedStringKey.font] = dataSource.meme.font
        
        let topText = dataSource.meme.topText
        let bottomText = dataSource.meme.bottomText
        
        var title = topText
        if topText != "" && bottomText != "" { title += "\n\n" }
        title += bottomText
        
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)

        memeLabel.attributedText = attributedString
    }
    
    fileprivate func configureCell() {
        backgroundColor = Constants.ColorScheme.whiteAlpha50
    }
}
