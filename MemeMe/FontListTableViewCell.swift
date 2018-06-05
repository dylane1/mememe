//
//  TextWithCheckMarkTableViewCell.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/2/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol FontListTableViewCellDataSource {
    var title: String { get }
    var font: UIFont { get }
    var textAttributes: [String : AnyObject] { get }
}

extension FontListTableViewCellDataSource {
    var textAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Constants.ColorScheme.white,
            NSStrokeColorAttributeName:     Constants.ColorScheme.darkGrey,
            NSStrokeWidthAttributeName:     -3.0 as AnyObject
        ]
    }
}

struct FontListTableViewCellModel: FontListTableViewCellDataSource {
    var title: String
    var font: UIFont
}

class FontListTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var label: UILabel!
    
    fileprivate var dataSource: FontListTableViewCellDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear //Constants.ColorScheme.lightGrey
    }
    
    internal func configure(withDataSource dataSource: FontListTableViewCellDataSource) {
        self.dataSource = dataSource
        
        configureLabel()
    }
    
    fileprivate func configureLabel() {
        let resizedFont = dataSource.font.withSize(20)
        let attributedString = NSMutableAttributedString(string: dataSource.title.uppercased(), attributes: dataSource.textAttributes)
        attributedString.addAttribute(NSFontAttributeName, value: resizedFont, range: NSRange(location: 0,length: dataSource.title.characters.count))
        
        label.attributedText = attributedString
    }
}
