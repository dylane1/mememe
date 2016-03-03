//
//  File.swift
//  Pitch Perfect
//
//  Created by Dylan Edwards on 1/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

struct Constants {
    /** Storyboard */
    struct StoryBoardIDs {
        static let main              = "Main"
        static let fontListTableVC   = "sb_fontListTableVC"
    }
    
    struct ReuseIDs {
        static let fontListTableCell = "ruid_FontListTableCell"
    }
    
    /** UI */
    struct ColorScheme {
        static let blue         = UIColor.blueColor()
        static let white        = UIColor.whiteColor()
        static let whiteAlpha50 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.50)
        static let lightGrey    = UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 1.00) //CBCBCB
    }
    
    static let fontSize: CGFloat = 32.0

    struct FontFamilyNames {
        static let americanTypewriter   = "American Typewriter"
        static let arial                = "Arial"
        static let avenir               = "Avenir"
        static let avenirNext           = "Avenir Next"
        static let avenirNextCondensed  = "Avenir Next Condensed"
        static let copperplate          = "Copperplate"
        static let futura               = "Futura"
        static let gillSans             = "Gill Sans"
        static let hoeflerText          = "Hoefler Text"
        static let impact               = "Impact"
        static let markerFelt           = "Marker Felt"
    }
    
    struct FontNames {
        static let americanTypewriter   = "AmericanTypewriter-Bold"
        static let arial                = "Arial-BoldMT"
        static let avenir               = "Avenir-Black"
        static let avenirNext           = "AvenirNext-Heavy"
        static let avenirNextCondensed  = "AvenirNextCondensed-Heavy"
        static let copperplate          = "Copperplate-Bold"
        static let futura               = "Futura-CondensedExtraBold"
        static let gillSans             = "GillSans-Bold"
        static let hoeflerText          = "HoeflerText-Black"
        static let impact               = "Impact"
        static let markerFelt           = "MarkerFelt-Wide"
    }
    
    struct Fonts {
//            static let defaultFont = UIFont.boldSystemFontOfSize(32)
        static let americanTypewriter   = UIFont(name: Constants.FontNames.americanTypewriter, size: Constants.fontSize)!
        static let arial                = UIFont(name: Constants.FontNames.arial, size: Constants.fontSize)!
        static let avenir               = UIFont(name: Constants.FontNames.avenir, size: Constants.fontSize)!
        static let avenirNext           = UIFont(name: Constants.FontNames.avenirNext, size: Constants.fontSize)!
        static let avenirNextCondensed  = UIFont(name: Constants.FontNames.avenirNextCondensed, size: Constants.fontSize)!
        static let copperplate          = UIFont(name: Constants.FontNames.copperplate, size: Constants.fontSize)!
        static let futura               = UIFont(name: Constants.FontNames.futura, size: Constants.fontSize)!
        static let gillSans             = UIFont(name: Constants.FontNames.gillSans, size: Constants.fontSize)!
        static let hoeflerText          = UIFont(name: Constants.FontNames.hoeflerText, size: Constants.fontSize)!
        static let impact               = UIFont(name: Constants.FontNames.impact, size: Constants.fontSize)!
        static let markerFelt           = UIFont(name: Constants.FontNames.markerFelt, size: Constants.fontSize)!
    }
    
    static let FontArray = [
        Constants.Fonts.americanTypewriter,
        Constants.Fonts.arial,
        Constants.Fonts.avenir,
        Constants.Fonts.avenirNext,
        Constants.Fonts.avenirNextCondensed,
        Constants.Fonts.copperplate,
        Constants.Fonts.futura,
        Constants.Fonts.gillSans,
        Constants.Fonts.hoeflerText,
        Constants.Fonts.impact,
        Constants.Fonts.markerFelt
    ]
    
    static let FontFamilyNameArray = [
        Constants.FontFamilyNames.americanTypewriter,
        Constants.FontFamilyNames.arial,
        Constants.FontFamilyNames.avenir,
        Constants.FontFamilyNames.avenirNext,
        Constants.FontFamilyNames.avenirNextCondensed,
        Constants.FontFamilyNames.copperplate,
        Constants.FontFamilyNames.futura,
        Constants.FontFamilyNames.gillSans,
        Constants.FontFamilyNames.hoeflerText,
        Constants.FontFamilyNames.impact,
        Constants.FontFamilyNames.markerFelt
    ]
    
    static let textAttributes = [
        NSForegroundColorAttributeName: Constants.ColorScheme.white,
        NSStrokeColorAttributeName:     UIColor.blackColor(),
        NSStrokeWidthAttributeName:     -5.0,
    ]
    
    
    /**
     * StorageKeys for saving to disk via NSCoding
     *
     * NSCoding has been replaced by NSJSONSerialization
     */
//    struct StorageKeys {
//        static let topText          = "com.slingingpixels.mememe.storageKeys.topText"
//        static let bottomText       = "com.slingingpixels.mememe.storageKeys.bottomText"
//        static let imageData        = "com.slingingpixels.mememe.storageKeys.imageData"
//        static let memedImageData   = "com.slingingpixels.mememe.storageKeys.memedImageData"
//        static let memeArray        = "com.slingingpixels.mememe.storageKeys.memeArray"
//    }
    
    struct FileSystem {
        static let applicationSupport = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
    }
    
    struct ArchiveFiles {
        static let storedMemes = FileSystem.applicationSupport + "/storedMemes.json"
    }
}
