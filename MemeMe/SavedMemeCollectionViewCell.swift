//
//  SavedMemesCollectionViewCell.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesCollectionViewCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var memeImageView: UIImageView!
    
    fileprivate var dataSource: SavedMemeCellDataSource!
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = Constants.ColorScheme.whiteAlpha70
    }
    
    //MARK: - Configuration
    
    internal func configure(withDataSource dataSource: SavedMemeCellDataSource) {
        self.dataSource = dataSource
        configureImageView()
    }
    
    fileprivate func configureImageView() {
        memeImageView.backgroundColor = Constants.ColorScheme.darkGrey
        memeImageView.image = dataSource.meme.memedImage
    }
}
