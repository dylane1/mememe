//
//  MemeStorage.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/24/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

/*******************************************************************************
 * This is one way to store data persistently, but has been replaced by 
 * MemeStorage.swift, which uses a more "Swifty" approach to storage....
 *
 *******************************************************************************/
//import UIKit
//
//final class StoredMeme: NSObject, NSCoding {
//    var topText: String
//    var bottomText: String
//    var image: UIImage
//    var memedImage: UIImage
//    
//    required convenience init?(coder decoder: NSCoder) {
//        var meme = Meme()
//        meme.topText    = decoder.decodeObjectForKey(Constants.StorageKeys.topText) as? String ?? ""
//        meme.bottomText = decoder.decodeObjectForKey(Constants.StorageKeys.bottomText) as? String ?? ""
//        meme.image      = UIImage(data: decoder.decodeObjectForKey(Constants.StorageKeys.imageData) as! NSData)
//        meme.memedImage = UIImage(data: decoder.decodeObjectForKey(Constants.StorageKeys.memedImageData) as! NSData)
//        
//        self.init(fromMeme: meme)
//    }
//    
//    init(fromMeme meme: Meme) {
//        topText     = meme.topText as String! ?? ""
//        bottomText  = meme.bottomText as String! ?? ""
//        image       = meme.image
//        memedImage  = meme.memedImage!
//        
//        super.init()
//    }
//    
//    //MARK: - NSCoding
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(topText, forKey: Constants.StorageKeys.topText)
//        aCoder.encodeObject(bottomText, forKey: Constants.StorageKeys.bottomText)
//        
//        let imageData = UIImagePNGRepresentation(image)
//        aCoder.encodeObject(imageData, forKey: Constants.StorageKeys.imageData)
//        
//        let memedImageData = UIImagePNGRepresentation(memedImage)
//        aCoder.encodeObject(memedImageData, forKey: Constants.StorageKeys.memedImageData)
//    }
//}
//
//
//final class MemesProvider: NSObject {
//    private var doLoadMemesFromStorage = true
//    private lazy var _memeArray = [StoredMeme]()
//    var memeArray: [StoredMeme] {
//        get {
//            if doLoadMemesFromStorage {
//                doLoadMemesFromStorage = false
//                
//                /** First load call is to an empty file */
//                if let data = loadMemesFromStorage() as [StoredMeme]! {
//                    _memeArray = data
//                    
//                    for meme in _memeArray {
//                        magic("meme: \(meme.topText)\n")
//                    }
//                }
//            }
//            return _memeArray
//        }
//        set {
//            _memeArray = newValue
//            saveMemesToStorage(_memeArray)
//        }
//    }
//    
//    private func loadMemesFromStorage() -> [StoredMeme]? {
//        let memesData = NSKeyedUnarchiver.unarchiveObjectWithFile(Constants.ArchiveFiles.memes) as? [StoredMeme]
//        
//        return memesData
//    }
//    
//    private func saveMemesToStorage(array: [StoredMeme]) {
//        NSKeyedArchiver.archiveRootObject(array, toFile: Constants.ArchiveFiles.memes)
//    }
//}

