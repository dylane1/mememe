//
//  MemeStorage.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 2/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

/**
* Adapted from these StackOverflow questions:
*
* http://stackoverflow.com/questions/33186051/swift-convert-struct-to-json
* http://stackoverflow.com/questions/28768015/how-to-save-an-array-as-a-json-file-in-swift
*/

import UIKit

struct StoredMeme {
    internal var imageName: String
    internal var topText: String
    internal var bottomText: String
    internal var fontName: String
    internal var fontColorName: String
    internal var memedImageName: String
    
    internal var jsonDictionary: [String: String] {
        return [
            "imageName": imageName,
            "topText": topText,
            "bottomText": bottomText,
            "fontName": fontName,
            "fontColorName": fontColorName,
            "memedImageName": memedImageName]
    }
    
    init(){
        imageName       = ""
        topText         = ""
        bottomText      = ""
        fontName        = ""
        fontColorName   = ""
        memedImageName  = ""
    }
}

/** 
 * Responsible for writing and retrieving JSON data to/from the archive file
 * stored in the Application Support directory
 */
struct MemesProvider {

    fileprivate var storedMemeArray: [StoredMeme]
    
    fileprivate var _memeArray = [Meme]()
    internal var memeArray: [Meme] {
        return _memeArray
    }
    
    init() {
        storedMemeArray = [StoredMeme]()
        _memeArray = [Meme]()
        loadMemesFromStorage()
    }
    
    mutating internal func addNewMemeToStorage(_ meme: Meme, completion: (() -> Void)?) {        
        _memeArray.append(meme)
        
        let storedMeme = createStoredMeme(fromMeme: meme) // StoredMeme()
        
        storedMemeArray.append(storedMeme)
        
        /** Write storedMemesArray to archive file */
        createJSONDataAndSave(withArray: storedMemeArray, completion: completion)
    }
    
    mutating internal func removeMemeFromStorage(atIndex index: Int) {
        _memeArray.remove(at: index)
        storedMemeArray.remove(at: index)
        
        /** Write storedMemesArray to archive file */
        createJSONDataAndSave(withArray: storedMemeArray, completion: nil)
    }
    
    mutating internal func updateMemeFromStorage(atIndex index: Int, withMeme meme: Meme, completion: (() -> Void)?) {
        _memeArray[index] = meme
        
        let storedMeme = createStoredMeme(fromMeme: meme)
        
        storedMemeArray[index] = storedMeme
        
        /** Write storedMemesArray to archive file */
        createJSONDataAndSave(withArray: storedMemeArray, completion: completion)
    }
    
    fileprivate func createStoredMeme(fromMeme meme: Meme) -> StoredMeme {
        var storedMeme = StoredMeme()
        
        storedMeme.imageName        = saveImageAndGetName(meme.image!)
        storedMeme.topText          = meme.topText
        storedMeme.bottomText       = meme.bottomText
        storedMeme.fontName         = getFontName(meme.font)
        storedMeme.fontColorName    = getFontColorName(meme.fontColor)
        storedMeme.memedImageName   = saveImageAndGetName(meme.memedImage!)
        
        return storedMeme
    }
    
    fileprivate func saveImageAndGetName(_ image: UIImage) -> String {
        let imageName = UUID().uuidString + ".jpeg"
        let filename = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            try? imageData.write(to: URL(fileURLWithPath: filename), options: [.atomic])
        }
        
        return imageName
    }
    
    fileprivate func getFontName(_ font: UIFont) -> String {
        for i in 0..<Constants.FontArray.count {
            if font == Constants.FontArray[i] {
                return Constants.FontFamilyNameArray[i]
            }
        }
        return Constants.FontName.impact
    }
    
    fileprivate func getFontFromFontName(_ name: String) -> UIFont {
        for i in 0..<Constants.FontFamilyNameArray.count {
            if name == Constants.FontFamilyNameArray[i] {
                return Constants.FontArray[i]
            }
        }
        return Constants.Font.impact
    }
    
    fileprivate func getFontColorName(_ color: UIColor) -> String {
        for i in 0..<Constants.FontColorArray.count {
            if color == Constants.FontColorArray[i] {
                return Constants.FontColorStringArray[i]
            }
        }
        return Constants.FontColorStringArray[0]
    }
    
    fileprivate func getColorFromColorName(_ name: String) -> UIColor {
        for i in 0..<Constants.FontColorStringArray.count {
            if name == Constants.FontColorStringArray[i] {
                return Constants.FontColorArray[i]
            }
        }
        return Constants.FontColorArray[0]
    }
    
    fileprivate func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        return documentsDirectory as NSString
    }
    
    fileprivate func createJSONDataAndSave(withArray array: [StoredMeme], completion: (()->Void)?) {
        var jsonArray = [[String: String]]()
        
        for item in array {
            jsonArray.append(item.jsonDictionary)
        }

        var jsonData: Data!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let error as NSError {
            magic("Array to JSON conversion failed: \(error.localizedDescription)")
        }
        
        /** Write (or overrite existing) json file */
        let fileManager = FileManager.default
        
        if !fileManager.createFile(atPath: Constants.ArchiveFile.storedMemes, contents: jsonData, attributes: nil) {
            magic("Error creating archive json file! Error code: \(errno); message: \(strerror(errno))")
        } else {
            /** Success */
            completion?()
        }
    }
    
    mutating fileprivate func loadMemesFromStorage() {
        
        guard let jsonData = (try? Data(contentsOf: URL(fileURLWithPath: Constants.ArchiveFile.storedMemes))) as Data! else { return }
        
        var jsonArray: [[String:String]]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String:String]]
            
        } catch let error as NSError {
            magic("Error creating jsonArray: \(error.localizedDescription)")
            return
        }
        
        var memes = [Meme]()
        var storedMemes = [StoredMeme]()
        
        for item in jsonArray {
            var meme = Meme()
            
            meme.image      = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(item["imageName"]!))
            meme.topText    = item["topText"]!
            meme.bottomText = item["bottomText"]!
            meme.font       = getFontFromFontName(item["fontName"]!)
            meme.fontColor  = getColorFromColorName(item["fontColorName"]!)
            meme.memedImage = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(item["memedImageName"]!))
            
            memes.append(meme)
            
            var storedMeme = StoredMeme()
            
            storedMeme.imageName        = item["imageName"]!
            storedMeme.topText          = item["topText"]!
            storedMeme.bottomText       = item["bottomText"]!
            storedMeme.fontName         = item["fontName"]!
            storedMeme.fontColorName    = item["fontColorName"]!
            storedMeme.memedImageName   = item["memedImageName"]!
            
            storedMemes.append(storedMeme)
        }
        storedMemeArray = storedMemes
        _memeArray = memes
    }
}
