//
//  StateMachine.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

enum AppState {
    case NoImageNoText,
         NoImageYesText,
         YesImageNoText,
         YesImageYesText
}

/** 
 Adapted (sort of) from this article: http://www.figure.ink/blog/2015/2/1/swift-state-machines-part-2
 */

class StateMachine {
    
    var state: Dynamic<AppState>
    
    init() {
        state = Dynamic(.NoImageNoText)
    }
    
    //TODO: May need to add an .IsEditingText state to enable Cancel button while editing, even though "Done" works
    func changeState(withImage img: UIImage?, topText: String?, bottomText: String?) {
        magic("\(img); \(topText); \(bottomText)")
        
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


//class NavControllerViewModel: NavigationControllerDataSource {
//    let shareButtonEnabled: Dynamic<Bool>
//    let cancelButtonEnabled: Dynamic<Bool>
//
//    private var state: AppState = .NoImageNoText {
//        didSet {
//            setButtonsEnabled()
//        }
//    }
//    private var stateMachine: StateMachine! {
//        didSet {
//            stateMachine.state.bindAndFire { [unowned self] in
//                self.state = $0
//            }
//        }
//    }
//
//    init(withAppState: StateMachine) {
//        shareButtonEnabled  = Dynamic(false)
//        cancelButtonEnabled = Dynamic(false)
//    }
//
//    private func setButtonsEnabled() {
//        switch state {
//        case .NoImageYesText, .YesImageNoText:
//            shareButtonEnabled.value = false
//            cancelButtonEnabled.value = true
//        case .YesImageYesText:
//            shareButtonEnabled.value = true
//            cancelButtonEnabled.value = true
//        default:
//            shareButtonEnabled.value = false
//            cancelButtonEnabled.value = false
//        }
//    }
//}
















