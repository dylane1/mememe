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
    //MARK: - View Lifecycle
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        buttonArray = [button0, button1, button2, button3, button4, button5, button6, button7]
        for button in buttonArray {
            button.backgroundColor = Constants.FontColorArray[button.tag]
        }
    }
    

    //MARK: - Internal funk(s)
    internal func configure(withSelectionClosure closure: ChangeColor) {
        didSelectColor = closure
    }
    
    
    @IBAction func buttonAction(sender: UIButton) {
        didSelectColor?(index: sender.tag)
    }
    
    
    //MARK: - Private funk(s)
    
    
    
}
