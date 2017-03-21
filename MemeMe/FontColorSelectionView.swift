//
//  FontColorSelectionView.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/4/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class FontColorSelectionView: UIView {

    typealias ChangeColor = (_ index: Int) -> Void
    fileprivate var didSelectColor: ChangeColor?

    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!

    fileprivate var buttonArray:[UIButton]!
    fileprivate var selectedColor: UIColor!

    //MARK: - Configuration
    
    internal func configure(withCurrentColor color: UIColor, selectionClosure closure: @escaping ChangeColor) {
        didSelectColor = closure
        selectedColor = color
        configureButtons()
    }
    
    //MARK: - Actions
    
    @IBAction func buttonAction(_ sender: UIButton) {
        didSelectColor?(sender.tag)
        selectedColor = Constants.FontColorArray[sender.tag]
        configureButtons()
    }
    
    fileprivate func configureButtons() {
        buttonArray = [button0, button1, button2, button3, button4, button5, button6, button7]
        for button in buttonArray {
            button.backgroundColor = Constants.FontColorArray[button.tag]
            button.layer.cornerRadius = 8;
            button.layer.borderWidth = 4;
            
            if button.backgroundColor == selectedColor {
                button.layer.borderColor = Constants.ColorScheme.darkGrey.cgColor
            } else {
                button.layer.borderColor = button.backgroundColor?.cgColor
            }
        }
    }
}
