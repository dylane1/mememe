//
//  MemeStorage.swift
//  MemeMe
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
    internal var topText: String
    internal var bottomText: String
    internal var imageName: String
    internal var memedImageName: String
    
    internal var jsonDictionary: [String: String] {
        return ["topText": topText,
                "bottomText": bottomText,
                "imageName": imageName,
                "memedImageName": memedImageName]
    }
    
    init(){
        topText         = ""
        bottomText      = ""
        imageName       = ""
        memedImageName  = ""
    }
}

/** 
 * Responsible for writing and retrieving JSON data to/from the archive file
 * stored in the Application Support directory
 */
struct MemesProvider {

    private var storedMemeArray: [StoredMeme]
    
    private var _memeArray = [Meme]()
    internal var memeArray: [Meme] {
        return _memeArray
    }
    
    init() {
        storedMemeArray = [StoredMeme]()
        _memeArray = [Meme]()
        loadMemesFromStorage()
    }
    
    mutating internal func addNewMemeToStorage(meme: Meme) {
        _memeArray.append(meme)
        
        var storedMeme = StoredMeme()
        
        storedMeme.topText          = meme.topText as String! ?? ""
        storedMeme.bottomText       = meme.bottomText as String! ?? ""
        storedMeme.imageName        = saveImageAndGetName(meme.image)
        storedMeme.memedImageName   = saveImageAndGetName(meme.memedImage!)
        
        storedMemeArray.append(storedMeme)
        
        /** Write storedMemesArray to archive file */
        createJSONDataAndSave(withArray: storedMemeArray)
    }
    
    private func saveImageAndGetName(image: UIImage) -> String {
        let imageName = NSUUID().UUIDString + ".png"
        let filename = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        
        if let imageData = UIImagePNGRepresentation(image) {
            imageData.writeToFile(filename, atomically: true)
        }
        
        return imageName
    }
    
    private func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
    
    private func createJSONDataAndSave(withArray array: [StoredMeme]) {
        var jsonArray = [[String: String]]()
        
        for item in array {
            jsonArray.append(item.jsonDictionary)
        }

        var jsonData: NSData!
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(jsonArray, options: NSJSONWritingOptions.PrettyPrinted)
//            magic("jsonData: \(String(data: jsonData, encoding: NSUTF8StringEncoding))")
        } catch let error as NSError {
            magic("Array to JSON conversion failed: \(error.localizedDescription)")
        }
        
        /** Write (or overrite existing) json file */
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.createFileAtPath(Constants.ArchiveFiles.storedMemes, contents: jsonData, attributes: nil) {
            magic("Error creating archive json file! Error code: \(errno); message: \(strerror(errno))")
        }
    }
    
    mutating private func loadMemesFromStorage() {
        
        guard let jsonData = NSData(contentsOfFile: Constants.ArchiveFiles.storedMemes) as NSData! else { return }
        
        var jsonArray: [[String:String]]!
        do {
            jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [[String:String]]
            
        } catch let error as NSError {
            magic("Error creating jsonArray: \(error.localizedDescription)")
            return
        }
        
        var memes = [Meme]()
        var storedMemes = [StoredMeme]()
        
        for item in jsonArray {
            var meme = Meme()
            
            meme.topText    = item["topText"]
            meme.bottomText = item["bottomText"]
            meme.image      = UIImage(contentsOfFile: getDocumentsDirectory().stringByAppendingPathComponent(item["imageName"]!))
            meme.memedImage = UIImage(contentsOfFile: getDocumentsDirectory().stringByAppendingPathComponent(item["memedImageName"]!))
            
            memes.append(meme)
            
            var storedMeme = StoredMeme()
            
            storedMeme.topText        = item["topText"]!
            storedMeme.bottomText     = item["bottomText"]!
            storedMeme.imageName      = item["imageName"]!
            storedMeme.memedImageName = item["memedImageName"]!
            
            storedMemes.append(storedMeme)
        }
        storedMemeArray = storedMemes
        _memeArray = memes
    }
}
