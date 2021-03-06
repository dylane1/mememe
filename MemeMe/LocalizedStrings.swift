//
//  LocalizedStrings.swift
//  Pitch Perfect
//
//  Created by Dylan Edwards on 1/27/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
import Foundation

struct LocalizedStrings {
    struct ViewControllerTitles {
        static let memeMe   = NSLocalizedString("vcTitles.memeMe",      value: "MemeMeister",    comment: "")
        static let newMeme  = NSLocalizedString("vcTitles.newMeme",     value: "New Meme",  comment: "")
        static let editMeme = NSLocalizedString("vcTitles.editMeme",    value: "Edit Meme", comment: "")
    }
    
    struct PlaceholderText {
        struct MainView {
            static let top      = NSLocalizedString("placeholder.top",    value: "ENTER TOP TEXT HERE",    comment: "")
            static let bottom   = NSLocalizedString("placeholder.bottom", value: "ENTER BOTTOM TEXT HERE", comment: "")
        }
    }
    
    struct NavigationControllerButtons {
        static let save     = NSLocalizedString("navBarButtons.save",   value: "Save",      comment: "")
        static let clear    = NSLocalizedString("navBarButtons.clear",  value: "Clear",     comment: "")
        static let cancel   = NSLocalizedString("navBarButtons.cancel", value: "Cancel",    comment: "")
        static let back     = NSLocalizedString("navBarButtons.back",   value: "Back",      comment: "")
    }
    
    struct ToolbarButtons {
        static let album    = NSLocalizedString("toolbarButtons.album", value: "Album", comment: "")
        static let font     = NSLocalizedString("toolbarButtons.font",  value: "Font",  comment: "")
        static let color    = NSLocalizedString("toolbarButtons.color", value: "Color", comment: "")
    }
    
    struct Alerts {
        struct ImageSaveError {
            static let title    = NSLocalizedString("imageSaveError.title",   value: "Save Error", comment: "")
            static let message  = NSLocalizedString("imageSaveError.message", value: "Sorry, image was not saved because: ", comment: "")
        }
        
        struct ShareError {
            static let title        = NSLocalizedString("shareError.title",         value: "Share Error", comment: "")
            static let message      = NSLocalizedString("shareError.message",       value: "Sorry, sharing meme was not successful because: ", comment: "")
            static let unknownError = NSLocalizedString("shareError.unknownError",  value: "Unknown Error", comment: "")
        }
        
        struct DeleteMemeConfirm {
            static let title    = NSLocalizedString("deleteMemeConfirm.title",   value: "Delete Meme", comment: "")
            static let message  = NSLocalizedString("deleteMemeConfirm.message", value: "Are you sure you want to permanently remove this meme?", comment: "")
        }
    }
    
    struct ButtonTitles {
        static let ok       = NSLocalizedString("buttonTitles.ok",      value: "OK",     comment: "")
        static let cancel   = NSLocalizedString("buttonTitles.cancel",  value: "Cancel", comment: "")
    }
    
    struct EmptyDataSetVCLabels {
        static let label0 = NSLocalizedString("emptyDataSetVC.label0", value: "Meme Like A Boss!",       comment: "")
        static let label1 = NSLocalizedString("emptyDataSetVC.label1", value: "Tap '+' above to get started!", comment: "")
    }
}
