//
//  KeyboardController.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/24/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit

@objc
public protocol ZKeyboardDelegate
{
    func zomojiWasSelected(withParams parameters: Dictionary<String,Any>)
    func backspaceWasPressed()
}

@objcMembers
public class KeyboardController: NSObject
{
    public static let zDictIsAnimoji = "isAnimoji"
    public static let zDictImageData = "imageData"
    public static let zDictStringEquivalent = "stringEquivalent"
    public static let zDictName = "name"
    public static let zDictNumberOfFrames = "numberOfFrames"
    public static let zDictStartingFrame = "startingFrame"
    
    public var delegate: ZKeyboardDelegate?
    
    private weak var keyboardView: KeyboardView?
    
    public func keyboard(withDelegate delegate: ZKeyboardDelegate?) -> UIView
    {
        if keyboardView == nil
        {
            keyboardView = KeyboardView()
        }
        
        keyboardView?.parentDelegate = delegate
        return keyboardView!
    }
    
    public func switchTheme(isDark: Bool)
    {
        UIColor.isDarkTheme = isDark
        UIColor.updateColorToSetTheme()
        keyboardView?.reloadBackgroundColor()
    }
}
