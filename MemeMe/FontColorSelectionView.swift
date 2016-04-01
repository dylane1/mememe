//
//  FontColorSelectionView.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/4/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class FontColorSelectionView: UIView {

    typealias ChangeColor = (index: Int) -> Void
    private var didSelectColor: ChangeColor?

    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!

    private var buttonArray:[UIButton]!
    private var selectedColor: UIColor!
    
    //MARK: - View Lifecycle
    
//    override func drawRect(rect: CGRect) {
//        
//    }
    

    //MARK: - Configuration
    
    internal func configure(withCurrentColor color: UIColor, selectionClosure closure: ChangeColor) {
        didSelectColor = closure
        selectedColor = color
        configureButtons()
    }
    
    //MARK: - Actions
    
    @IBAction func buttonAction(sender: UIButton) {
        didSelectColor?(index: sender.tag)
        selectedColor = Constants.FontColorArray[sender.tag]
        configureButtons()
    }
    
    private func configureButtons() {
        buttonArray = [button0, button1, button2, button3, button4, button5, button6, button7]
        for button in buttonArray {
            button.backgroundColor = Constants.FontColorArray[button.tag]
            button.layer.cornerRadius = 8;
            button.layer.borderWidth = 4;
            
            if button.backgroundColor == selectedColor {
                button.layer.borderColor = Constants.ColorScheme.darkGrey.CGColor
            } else {
                button.layer.borderColor = button.backgroundColor?.CGColor
            }
        }
    }
}
