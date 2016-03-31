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
        // Initialization code
    }

    internal func configure(withDataSource dataSource: SavedMemeCellDataSource) {
        self.dataSource = dataSource
        configureImageView()
        configureLabel()
    }
    
    private func configureImageView() {
        memeImageView.backgroundColor = Constants.ColorScheme.darkGrey
        memeImageView.image = dataSource.image
    }
    
    private func configureLabel() {
        memeLabel.adjustsFontSizeToFitWidth  = true
        
        var attributes = dataSource.textAttributes
        attributes[NSFontAttributeName] = dataSource.font!
        
        let attributedString = NSMutableAttributedString(string: dataSource.title, attributes: attributes)

        memeLabel.attributedText = attributedString
    }
}
