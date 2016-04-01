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
    struct StoryBoardID {
        static let main                     = "Main"
        static let fontListTableVC          = "sb_fontListTableVC"
        static let fontColorSelectionVC     = "sb_fontColorSelectionVC"
        static let sentMemesVC              = "sb_sentMemesVC"
        static let memesEditorNavController = "sb_memesEditorNavController"
        static let memesEditorVC            = "sb_memesEditorVC"
        static let emptyDataSetVC           = "sb_emptyDataSetVC"
    }
    
    struct ReuseID {
        static let fontListTableCell        = "ruid_fontListTableCell"
        static let memeListTableCell        = "ruid_memeListTableCell"
        static let memeListCollectionCell   = "ruid_memeListCollectionCell"
    }
    
    /** Segue */
    
    struct SegueID {
        static let memeDetail = "seg_memeDetail"
    }
     
    
    /** UI */
    struct ColorScheme {
        static let white        = UIColor(red: 0.969, green: 0.969, blue: 0.941, alpha: 1.00) //F7F7F0
        static let whiteAlpha50 = UIColor(red: 0.969, green: 0.969, blue: 0.941, alpha: 0.50)
        static let whiteAlpha70 = UIColor(red: 0.969, green: 0.969, blue: 0.941, alpha: 0.70)
        static let whiteAlpha90 = UIColor(red: 0.969, green: 0.969, blue: 0.941, alpha: 0.90)
        static let lightGrey    = UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 1.00) //CBCBCB
        static let mediumGrey   = UIColor(red: 0.409, green: 0.409, blue: 0.409, alpha: 1.00)
        static let darkGrey     = UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.00) //262626
        static let darkBlueGrey = UIColor(red:0.20, green:0.30, blue:0.31, alpha:1.00) //324D4E //UIColor(red: 0.160, green: 0.240, blue: 0.240, alpha: 1.00) 
        static let black        = UIColor(red: 0.010, green: 0.010, blue: 0.010, alpha: 1.00)
        static let lightBlue    = UIColor(red: 0.243, green: 0.733, blue: 0.655, alpha: 1.00) //3EBBA7
        static let mediumBlue   = UIColor(red: 0.000, green: 0.560, blue: 0.590, alpha: 1.00) //008F97
        static let darkBlue     = UIColor(red: 0.000, green: 0.455, blue: 0.478, alpha: 1.00) //00747A
        static let veryDarkBlue = UIColor(red: 0.000, green: 0.150, blue: 0.160, alpha: 1.00) //002729
        static let orange       = UIColor(red: 1.000, green: 0.616, blue: 0.200, alpha: 1.00) //FF9D33
        static let red          = UIColor(red: 0.800, green: 0.200, blue: 0.200, alpha: 1.00) //CC3333
        static let green        = UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1.00) //7ED321
        static let purple       = UIColor(red: 0.294, green: 0.180, blue: 0.631, alpha: 1.00) //4B2EA1
        static let yellow       = UIColor(red: 0.898, green: 0.792, blue: 0.090, alpha: 1.00) //E5CA17
    }
    
    static let FontColorStringArray = [
        "White",
        "Yellow",
        "Orange",
        "Red",
        "Purple",
        "Dark Blue",
        "Light Blue",
        "Green"
    ]
    
    static let FontColorArray = [
        Constants.ColorScheme.white,
        Constants.ColorScheme.yellow,
        Constants.ColorScheme.orange,
        Constants.ColorScheme.red,
        Constants.ColorScheme.purple,
        Constants.ColorScheme.darkBlue,
        Constants.ColorScheme.lightBlue,
        Constants.ColorScheme.green
    ]
    
    static let fontSize: CGFloat = 32.0

    struct FontFamilyName {
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
    
    struct FontName {
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
    
    struct Font {
        static let americanTypewriter   = UIFont(name: Constants.FontName.americanTypewriter, size: Constants.fontSize)!
        static let arial                = UIFont(name: Constants.FontName.arial, size: Constants.fontSize)!
        static let avenir               = UIFont(name: Constants.FontName.avenir, size: Constants.fontSize)!
        static let avenirNext           = UIFont(name: Constants.FontName.avenirNext, size: Constants.fontSize)!
        static let avenirNextCondensed  = UIFont(name: Constants.FontName.avenirNextCondensed, size: Constants.fontSize)!
        static let copperplate          = UIFont(name: Constants.FontName.copperplate, size: Constants.fontSize)!
        static let futura               = UIFont(name: Constants.FontName.futura, size: Constants.fontSize)!
        static let gillSans             = UIFont(name: Constants.FontName.gillSans, size: Constants.fontSize)!
        static let hoeflerText          = UIFont(name: Constants.FontName.hoeflerText, size: Constants.fontSize)!
        static let impact               = UIFont(name: Constants.FontName.impact, size: Constants.fontSize)!
        static let markerFelt           = UIFont(name: Constants.FontName.markerFelt, size: Constants.fontSize)!
    }
    
    static let FontArray = [
        Constants.Font.americanTypewriter,
        Constants.Font.arial,
        Constants.Font.avenir,
        Constants.Font.avenirNext,
        Constants.Font.avenirNextCondensed,
        Constants.Font.copperplate,
        Constants.Font.futura,
        Constants.Font.gillSans,
        Constants.Font.hoeflerText,
        Constants.Font.impact,
        Constants.Font.markerFelt
    ]
    
    static let FontFamilyNameArray = [
        Constants.FontFamilyName.americanTypewriter,
        Constants.FontFamilyName.arial,
        Constants.FontFamilyName.avenir,
        Constants.FontFamilyName.avenirNext,
        Constants.FontFamilyName.avenirNextCondensed,
        Constants.FontFamilyName.copperplate,
        Constants.FontFamilyName.futura,
        Constants.FontFamilyName.gillSans,
        Constants.FontFamilyName.hoeflerText,
        Constants.FontFamilyName.impact,
        Constants.FontFamilyName.markerFelt
    ]
    
    
    /** Storage */
    
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    struct StorageKeys {
        static let fontName     = "com.slingingPixels.mememe.storageKeys.fontName"
        static let fontColor    = "com.slingingPixels.mememe.storageKeys.fontColor"
    }

    
    struct FileSystem {
        static let applicationSupport = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
    }
    
    struct ArchiveFile {
        static let storedMemes = FileSystem.applicationSupport + "/storedMemes.json"
    }
}
