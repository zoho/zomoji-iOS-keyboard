//
//  Extensions.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/15/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit

internal extension UserDefaults
{
    class func keyboardDefaults() -> UserDefaults?
    {
        return UserDefaults.init(suiteName: "com.zoho.keyboard")
    }
}

internal extension UIImage
{
    convenience init?(withName name: String)
    {
        let bundle = Bundle(for: KeyboardController.classForCoder())
        
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}

internal extension UIView
{
    func setShadow()
    {
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
}

internal extension Bool
{
    func loopCount() -> UInt
    {
        if self
        {
            return 0
        }
        else
        {
            return 1
        }
    }
}

internal extension UIColor
{
    static var tabBg = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    static var keyboardBg = UIColor.black
    static var selectedSectionButton = UIColor.white
    static var sectionButton = UIColor.white.withAlphaComponent(0.3)
    static var shadow = UIColor.white
    static var backSpace = UIColor.white.withAlphaComponent(0.5)
    static var isDarkTheme = true
    
    class func updateColorToSetTheme()
    {
        if UIColor.isDarkTheme
        {
            UIColor.tabBg = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
            UIColor.keyboardBg = UIColor.black
            UIColor.selectedSectionButton = UIColor.white
            UIColor.sectionButton = UIColor.white.withAlphaComponent(0.3)
            UIColor.backSpace = UIColor.white.withAlphaComponent(0.5)
            UIColor.shadow = UIColor.white
        }
        else
        {
            UIColor.tabBg = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
            UIColor.keyboardBg = UIColor.white
            UIColor.selectedSectionButton = UIColor.black
            UIColor.sectionButton = UIColor.black.withAlphaComponent(0.3)
            UIColor.backSpace = UIColor.black.withAlphaComponent(0.5)
            UIColor.shadow = UIColor.black
        }
    }
}
