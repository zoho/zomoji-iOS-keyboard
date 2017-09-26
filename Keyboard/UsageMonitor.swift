//
//  UsageMonitor.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/25/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit

internal typealias CountDictionary = Dictionary<String, Double>

internal class UsageMonitor: NSObject
{
    private static let DefaultsEmojiCountKey = "zkeyboard_emoji_count"
    private static let DefaultsAnimojiCountKey = "zkeyboard_animoji_count"
    
    static var emojiDefaultsDict: CountDictionary?
    static var animojiDefaultsDict: CountDictionary?
    
    class func selected(emoji: Emoji)
    {
        guard emojiDefaultsDict != nil
        else
        {
            return
        }
        
        if let count = emojiDefaultsDict![emoji.rawValue]
        {
            emojiDefaultsDict![emoji.rawValue] = count + 1
        }
        else
        {
            emojiDefaultsDict![emoji.rawValue] = 1
        }
        
        self.set(emojiCount: emojiDefaultsDict!)
    }
    
    class func selected(animoji: Animoji)
    {
        guard animojiDefaultsDict != nil
        else
        {
            return
        }
        
        if let count = animojiDefaultsDict![animoji.rawValue]
        {
            animojiDefaultsDict![animoji.rawValue] = count + 1
        }
        else
        {
            animojiDefaultsDict![animoji.rawValue] = 1
        }
        
        self.set(animojiCount: animojiDefaultsDict!)
    }
    
    class func setTopEmoji()
    {
        let topEmojiKeys = self.checkAndGetEmojiKeys()

        var topEmojiArray = [Emoji]()

        for topEmoji in topEmojiKeys
        {
            if let emojiValue = Emoji(rawValue: topEmoji)
            {
                topEmojiArray.append(emojiValue)
            }
        }

        emojisArray[0] = topEmojiArray
    }
    
    class func setTopAnimoji()
    {
        let topAnimojiKeys = self.checkAndGetAnimojiKeys()
        
        var topAnimojiArray = [(Animoji, Bool)]()
        
        for topAnimoji in topAnimojiKeys
        {
            if let animojiValue = Animoji(rawValue: topAnimoji)
            {
                topAnimojiArray.append((animojiValue, true))
            }
        }
        
        animojisArray[0] = topAnimojiArray
    }
    
    private class func checkAndGetEmojiKeys() -> [String]
    {
        let defaults = UserDefaults.keyboardDefaults()
        
        if let countDict = defaults?.value(forKey: DefaultsEmojiCountKey) as? CountDictionary
        {
            self.emojiDefaultsDict = countDict
            
            let sortedKeys = self.sortAndReturnKeys(ofDictionary: countDict)
            return sortedKeys
        }
        else
        {
            return self.initialiseEmojiDefaults()
        }
    }
    
    private class func checkAndGetAnimojiKeys() -> [String]
    {
        let defaults = UserDefaults.keyboardDefaults()
        
        if let countDict = defaults?.value(forKey: DefaultsAnimojiCountKey) as? CountDictionary
        {
            self.animojiDefaultsDict = countDict
            
            let sortedKeys = self.sortAndReturnKeys(ofDictionary: countDict)
            return sortedKeys
        }
        else
        {
            return self.initialiseAnimojiDefaults()
        }
    }
    
    private class func initialiseEmojiDefaults() -> [String]
    {
        var countDict = CountDictionary()
        var keysList = [String]()
        
        for emoji in frequentEmojis
        {
            keysList.append(emoji.rawValue)
            countDict[emoji.rawValue] = 5
        }

        self.emojiDefaultsDict = countDict
        
        self.set(emojiCount: countDict)
        
        return keysList
    }
    
    private class func initialiseAnimojiDefaults() -> [String]
    {
        var countDict = CountDictionary()
        var keysList = [String]()
        
        for animoji in frequentAnimojis
        {
            keysList.append(animoji.rawValue)
            countDict[animoji.rawValue] = 5
        }
        
        self.animojiDefaultsDict = countDict
        
        self.set(animojiCount: countDict)
        
        return keysList
    }
    
    private class func set(emojiCount countDictionary: CountDictionary)
    {
        let defaults = UserDefaults.keyboardDefaults()
        
        defaults?.setValue(countDictionary, forKey: DefaultsEmojiCountKey)
        
        defaults?.synchronize()
    }
    
    private class func set(animojiCount countDictionary: CountDictionary)
    {
        let defaults = UserDefaults.keyboardDefaults()
        
        defaults?.setValue(countDictionary, forKey: DefaultsAnimojiCountKey)
        
        defaults?.synchronize()
    }
    
    private class func sortAndReturnKeys(ofDictionary dictionary: CountDictionary) -> [String]
    {
        let keys = dictionary.keys
        
        let sortedArray = keys.sorted(by:
        {
            (firstKey: String, secondKey: String) -> Bool in
            
            if let firstValue = dictionary[firstKey], let secondValue = dictionary[secondKey]
            {
                if firstValue > secondValue
                {
                    return true
                }
                else
                {
                    return false
                }
            }
            else
            {
                return true
            }
        })
        
        if sortedArray.count > 16
        {
            return Array(sortedArray[0...16])
        }
        
        return sortedArray
    }
}
