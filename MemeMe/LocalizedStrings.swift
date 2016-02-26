//
//  LocalizedStrings.swift
//  Pitch Perfect
//
//  Created by Dylan Edwards on 1/27/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
import Foundation

struct LocalizedStrings {
    internal struct ViewControllerTitles {
        static let memeMe = NSLocalizedString("vcTitles.memeMe", value: "MemeMe", comment: "")
    }
    
    internal struct PlaceholderText {
        struct MainView {
            static let top      = NSLocalizedString("placeholder.top",    value: "Top",    comment: "")
            static let bottom   = NSLocalizedString("placeholder.bottom", value: "Bottom", comment: "")
        }
    }
    
    internal struct NavigationControllerButtons {
        static let cancel   = NSLocalizedString("navButtons.cancel", value: "Cancel", comment: "")
        static let album    = NSLocalizedString("navButtons.album",  value: "Album",  comment: "")
    }
    
    internal struct ErrorAlerts {
        struct ImageSaveError {
            static let title    = NSLocalizedString("imageSaveError.title",   value: "Save Error", comment: "")
            static let message  = NSLocalizedString("imageSaveError.message", value: "Sorry, image was not saved because: ", comment: "")
        }
        
        struct ShareError {
            static let title        = NSLocalizedString("shareError.title",   value: "Share Error", comment: "")
            static let message      = NSLocalizedString("shareError.message", value: "Sorry, sharing meme was not successful because: ", comment: "")
            static let unknownError = NSLocalizedString("shareError.unknownError", value: "Unknown Error", comment: "")
        }
    }
    
    internal struct ButtonTitles {
        static let ok = NSLocalizedString("buttonTitles.ok", value: "OK", comment: "")
    }
}
