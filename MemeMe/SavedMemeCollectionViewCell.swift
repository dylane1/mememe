//
//  SavedMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemesCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var memeImageView: UIImageView!
    
    private var dataSource: SavedMemeCellDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = Constants.ColorScheme.white
    }
    
    internal func configure(withDataSource dataSource: SavedMemeCellDataSource) {
        self.dataSource = dataSource
        configureImageView()
    }
    
    private func configureImageView() {
        memeImageView.backgroundColor = Constants.ColorScheme.darkGrey
        memeImageView.image = dataSource.image
    }
}
