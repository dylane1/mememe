//
//  StateMachine.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 2/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

enum MemeEditorState {
    case NoImageNoText,
         NoImageYesText,
         YesImageNoText,
         YesImageYesText,
         IsEditingText
}

/** 
 Adapted (sort of) from this article: http://www.figure.ink/blog/2015/2/1/swift-state-machines-part-2
 */

final class MemeEditorStateMachine {
    /** 
     * MemeEditorNavigationItem is listening for changes in this var & 
     * enables/disables bar buttons based on current app state
     */
    internal var state: Dynamic<MemeEditorState>
    
    init() {
        state = Dynamic(.NoImageNoText)
    }
    
    internal func changeState(withImage img: UIImage?, topText: String?, bottomText: String?) {
        let image = (img == nil)                            ? false : true
        let tText = (topText == nil || topText == "")       ? false : true
        let bText = (bottomText == nil || bottomText == "") ? false : true
        
        let stateTuple = (image, tText, bText)
        switch stateTuple {
        case (true, false, false):
            state.value = .YesImageNoText
        case (false, true, false), (false, true, true), (false, false, true):
            state.value = .NoImageYesText
        case (true, true, false), (true, true, true), (true, false, true):
            state.value = .YesImageYesText
        default: /** (false, false, false) */
            state.value = .NoImageNoText
        }
    }
}
