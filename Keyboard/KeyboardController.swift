//
//  KeyboardController.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/24/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit

public let zDictIsAnimoji = "isAnimoji"
public let zDictImageData = "imageData"
public let zDictStringEquivalent = "stringEquivalent"
public let zDictName = "name"
public let zDictNumberOfFrames = "numberOfFrames"
public let zDictStartingFrame = "startingFrame"

public protocol ZKeyboardDelegate
{
    func zomojiWasSelected(withParams parameters: Dictionary<String,Any>)
    func backspaceWasPressed()
}

@objcMembers
public class KeyboardController: NSObject
{
    public var delegate: ZKeyboardDelegate?
    
    private weak var keyboardView: KeyboardView?
    
    public func keyboard(withDelegate delegate: ZKeyboardDelegate? = nil) -> UIView
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
