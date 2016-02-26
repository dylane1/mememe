//
//  File.swift
//  Pitch Perfect
//
//  Created by Dylan Edwards on 1/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

struct Constants {
    
    internal struct ColorScheme {
        static let blue         = UIColor.blueColor()
        static let white        = UIColor.whiteColor()
        static let whiteAlpha50 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.50)
    }
    
    internal struct Fonts {
        static let textFields = UIFont.systemFontOfSize(32, weight: UIFontWeightBold)
    }
    
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
    
    internal struct FileSystem {
        static let applicationSupport = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
    }
    
    internal struct ArchiveFiles {
        static let storedMemes = FileSystem.applicationSupport + "/storedMemes.json"
    }
}
