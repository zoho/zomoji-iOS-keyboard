//
//  KeyboardView.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/18/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit

internal protocol InteractionDelegate
{
    func scrollToSection(atIndex index: Int)
    func scrolledToSection(atIndex index: Int, forKeyboard type: ZKeyboardType)
    func showKeyboard(withType type: ZKeyboardType)
    func reloadBackgroundColor()
}

internal class KeyboardView: UIView
{
    override var intrinsicContentSize: CGSize
    {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 264)
    }
    
    var parentDelegate: ZKeyboardDelegate?
    {
        didSet
        {
            animojiKeyboard.parentDelegate = self.parentDelegate
            emojiKeyboard.parentDelegate = self.parentDelegate
            bottomTab.parentDelegate = self.parentDelegate
        }
    }
    
    var prevValue: Double = 0
    
    let animojiKeyboard = KeyboardCV(forType: ZKeyboardType.animoji)
    let emojiKeyboard = KeyboardCV(forType: ZKeyboardType.emoji)
    let bottomTab = CollectionViewTab()
    let topTab = KeyboardTab()
    
    var currentlyVisibleKeyboard = ZKeyboardType.emoji
    
    var leftConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initialise()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initialise()
    }
    
    init()
    {
        super.init(frame: CGRect.zero)
        self.initialise()
    }
    
    private func initialise()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.masksToBounds = false
        
        animojiKeyboard.translatesAutoresizingMaskIntoConstraints = false
        animojiKeyboard.interactionDelegate = self
        
        bottomTab.interactionDelegate = self
        bottomTab.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomTab)
        
        topTab.interactionDelegate = self
        topTab.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topTab)
        
        emojiKeyboard.translatesAutoresizingMaskIntoConstraints = false
        emojiKeyboard.interactionDelegate = self
        self.addSubview(emojiKeyboard)
        
        let viewsDict: [String: Any] = ["bottom": bottomTab, "top": topTab, "emoji": emojiKeyboard]
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[top(48)][emoji(168)][bottom(48)]|", options: [], metrics: nil, views: viewsDict))
        constraints.append(NSLayoutConstraint(item: emojiKeyboard, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottom]|", options: [], metrics: nil, views: viewsDict))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[top]|", options: [], metrics: nil, views: viewsDict))
        
        leftConstraint = NSLayoutConstraint(item: emojiKeyboard, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        constraints.append(leftConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension KeyboardView: InteractionDelegate
{
    func scrollToSection(atIndex index: Int)
    {
        if leftConstraint.constant < 0
        {
            self.animojiKeyboard.scroll(toIndex: index)
        }
        else
        {
            self.emojiKeyboard.scroll(toIndex: index)
        }
    }
    
    func scrolledToSection(atIndex index: Int, forKeyboard type: ZKeyboardType)
    {
        if currentlyVisibleKeyboard == type
        {
            self.bottomTab.selectButton(atIndex: index)
        }
    }
    
    func showKeyboard(withType type: ZKeyboardType)
    {
        currentlyVisibleKeyboard = type
        if type == ZKeyboardType.animoji
        {
            var isFirstTime = false
            
            if animojiKeyboard.superview == nil
            {
                isFirstTime = true
                
                self.addSubview(animojiKeyboard)
                
                self.bringSubview(toFront: emojiKeyboard)
                var constraints = [NSLayoutConstraint]()
                
                constraints.append(NSLayoutConstraint(item: animojiKeyboard, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: emojiKeyboard, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: animojiKeyboard, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: emojiKeyboard, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: animojiKeyboard, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: emojiKeyboard, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: animojiKeyboard, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: emojiKeyboard, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
                
                NSLayoutConstraint.activate(constraints)
                self.layoutSubviews()
            }
            
            leftConstraint.constant = -self.frame.width
            
            bottomTab.changed(toKeyboard: type, withSelectedIndex: animojiKeyboard.currentSection)
            
            UIView.animate(withDuration: 0.5, animations:
            {
                self.layoutIfNeeded()
            },
            completion:
            {
                (completed: Bool) in
                
                if isFirstTime
                {
                    self.animojiKeyboard.animateVisibleCells()
                }
            })
        }
        else
        {
            leftConstraint.constant = 0
            
            bottomTab.changed(toKeyboard: type, withSelectedIndex: emojiKeyboard.currentSection)
            
            UIView.animate(withDuration: 0.5, animations:
            {
                self.layoutIfNeeded()
            })
        }
    }
    
    func reloadBackgroundColor()
    {
        self.bottomTab.reloadColors()
        self.animojiKeyboard.backgroundColor = UIColor.keyboardBg
        self.emojiKeyboard.backgroundColor = UIColor.keyboardBg
        self.topTab.didSwitchColors()
    }
}
