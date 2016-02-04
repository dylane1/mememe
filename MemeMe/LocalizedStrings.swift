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
        static let memeMe   = NSLocalizedString("vcTitles.memeMe",      value: "MemeMe",    comment: "")
//        static let playback = NSLocalizedString("vcTitles.playback",    value: "Playback",  comment: "")
    }
    
    struct PlaceholderText {
        struct MainView {
            static let top      = NSLocalizedString("placeholder.top",      value: "Top",       comment: "")
            static let bottom   = NSLocalizedString("placeholder.bottom",   value: "Bottom",    comment: "")
        }
//
//        struct PlaybackAudioView {
//            static let effectDelay      = NSLocalizedString("labels.effectDelay",       value: "Delay",         comment: "")
//            static let effectDistortion = NSLocalizedString("labels.effectDistortion",  value: "Distortion",    comment: "")
//            static let effectReverb     = NSLocalizedString("labels.effectReverb",      value: "Reverb",        comment: "")
//        }
    }
    
    struct NavigationControllerButtons {
        static let cancel   = NSLocalizedString("navButtons.cancel", value: "Cancel", comment: "")
        static let album    = NSLocalizedString("navButtons.album", value: "Album", comment: "")
    }
}
