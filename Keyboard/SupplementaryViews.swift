//
//  SupplementaryViews.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/18/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit
import YYImage

internal class CollectionViewTab: UIView
{
    private var buttons: [UIButton] = []
    private var scrollView: UIScrollView = UIScrollView()
    private var deleteTimer: Timer?
    let deleteButton = UIButton(type: UIButtonType.system)
    
    private var selectedButton: UIButton?
    {
        didSet
        {
            if oldValue == selectedButton
            {
                return
            }
            
            oldValue?.tintColor = UIColor.sectionButton
            
            self.scrollView.scrollRectToVisible(self.selectedButton!.frame, animated: true)
            
            if indicatorCenterConstraint != nil
            {
                NSLayoutConstraint.deactivate([indicatorCenterConstraint!])
            }
            
            indicatorCenterConstraint = NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: selectedButton, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([indicatorCenterConstraint!])
            
            UIView.animate(withDuration: 0.3, animations:
            {
                self.layoutIfNeeded()
            })
            {
                (completed: Bool) in
                
                UIView.animate(withDuration: 0.3, animations:
                {
                    self.selectedButton?.tintColor = UIColor.selectedSectionButton
                })
            }
        }
    }
    
    private let indicatorView = UIView()
    var indicatorCenterConstraint: NSLayoutConstraint?
    
    var interactionDelegate: InteractionDelegate?
    var parentDelegate: ZKeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.keyboardBg
        
        var prevButton: UIButton?
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.layer.cornerRadius = 7
        indicatorView.layer.masksToBounds = true
        indicatorView.backgroundColor = UIColor.tabBg
        scrollView.addSubview(indicatorView)
        
        self.addSubview(scrollView)
        
        for i in 0..<emojiSectionImageNames.count
        {
            let button = UIButton(type: UIButtonType.system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = UIColor.sectionButton
            button.tag = i
            button.contentMode = UIViewContentMode.center
            button.setImage(UIImage(named: emojiSectionImageNames[i]), for: UIControlState.normal)
            button.addTarget(self, action: #selector(didSelect(button:)), for: UIControlEvents.touchUpInside)
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
            scrollView.addSubview(button)
            self.setConstraints(forButton: button, withPrevButton: prevButton)
            prevButton = button
            
            buttons.append(button)
        }
        
        scrollView.contentSize = CGSize(width: (emojiSectionImageNames.count - 1) * 41, height: 42)
        
        let firstButton = buttons[0]
        firstButton.tintColor = UIColor.selectedSectionButton
        selectedButton = firstButton
        
        deleteButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.tintColor = UIColor.backSpace
        deleteButton.setImage(UIImage(named: "Tab/Backspace"), for: UIControlState.normal)
        deleteButton.addTarget(self, action: #selector(deleteCancel), for: UIControlEvents.touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteCancel), for: UIControlEvents.touchUpOutside)
        deleteButton.addTarget(self, action: #selector(deleteTouchDown), for: UIControlEvents.touchDown)
        self.addSubview(deleteButton)
        
        var constraints: [NSLayoutConstraint] = []
        let viewsDict: [String: Any] = ["scroll": scrollView, "delete": deleteButton]
        
        constraints.append(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30))
        constraints.append(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30))
        constraints.append(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: firstButton, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))

        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[scroll][delete(40)]|", options: [], metrics: nil, views: viewsDict))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[scroll]|", options: [], metrics: nil, views: viewsDict))
        constraints.append(NSLayoutConstraint(item: deleteButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
        indicatorCenterConstraint = NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: firstButton, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        constraints.append(indicatorCenterConstraint!)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setConstraints(forButton button: UIButton, withPrevButton prevButton: UIButton?)
    {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36))
        constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36))
        constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
        if let prevButton = prevButton
        {
            constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: prevButton, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
        }
        else
        {
            constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 5))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func didSelect(button: UIButton)
    {
        self.selectedButton = button
        self.interactionDelegate?.scrollToSection(atIndex: selectedButton!.tag)
    }
    
    func selectButton(atIndex index: Int)
    {
        if index < buttons.count
        {
            self.selectedButton = buttons[index]
        }
    }
    
    func changed(toKeyboard keyboardType: ZKeyboardType, withSelectedIndex index: Int)
    {
        if keyboardType == ZKeyboardType.animoji
        {
            scrollView.contentSize = CGSize(width: (animojiSectionImageNames.count - 1) * 41, height: 42)

            for i in 0..<animojiSectionImageNames.count
            {
                let button = buttons[i]
                button.setImage(UIImage(named: animojiSectionImageNames[i]), for: UIControlState.normal)
            }
            
            for i in animojiSectionImageNames.count..<buttons.count
            {
                let button = buttons[i]
                button.isEnabled = false
                button.isHidden = true
            }
        }
        else
        {
            scrollView.contentSize = CGSize(width: (emojiSectionImageNames.count - 1) * 41, height: 42)

            for i in 0..<buttons.count
            {
                let button = buttons[i]
                button.setImage(UIImage(named: emojiSectionImageNames[i]), for: UIControlState.normal)
                button.isEnabled = true
                button.isHidden = false
            }
        }
        
        self.selectButton(atIndex: index)
    }
    
    func reloadColors()
    {
        for button in buttons
        {
            button.tintColor = UIColor.sectionButton
        }
        
        selectedButton?.tintColor = UIColor.selectedSectionButton
        deleteButton.tintColor = UIColor.backSpace
        
        self.backgroundColor = UIColor.keyboardBg
        self.indicatorView.backgroundColor = UIColor.tabBg
    }
    
    @objc func deletePressed()
    {
        parentDelegate?.backspaceWasPressed()
    }
    
    @objc func deleteTouchDown()
    {
        if self.deleteTimer == nil
        {
            self.deletePressed()
            
            deleteTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(deletePressed), userInfo: nil, repeats: true)
        }
    }
    
    @objc func deleteCancel()
    {
        deleteTimer?.invalidate()
        deleteTimer = nil
    }
}

internal class KeyboardTab: UIView
{
    let animatorView = YYAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    private var selectedButton: UIButton?
    {
        didSet
        {
            if indicatorCenterConstraint != nil
            {
                NSLayoutConstraint.deactivate([indicatorCenterConstraint!])
            }
            
            indicatorCenterConstraint = NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: selectedButton, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([indicatorCenterConstraint!])
            
            UIView.animate(withDuration: 0.3)
            {
                self.layoutIfNeeded()
            }
        }
    }
    
    private let indicatorView = UIView()
    var indicatorCenterConstraint: NSLayoutConstraint?
    var interactionDelegate: InteractionDelegate?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.tabBg
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.backgroundColor = UIColor(red:0.29, green:0.61, blue:0.89, alpha:1.00)
        self.addSubview(indicatorView)
        self.setConstraints(forIndicator: indicatorView)
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.00)
        self.addSubview(separator)
        self.setConstraints(forSeparator: separator)
        
        let staticImage = UIImageView(image: Emoji.smile.image())
        staticImage.translatesAutoresizingMaskIntoConstraints = false
        let buttonOne = UIButton(type: UIButtonType.custom)
        buttonOne.translatesAutoresizingMaskIntoConstraints = false
        buttonOne.tag = 1
        buttonOne.contentMode = UIViewContentMode.scaleToFill
        buttonOne.addTarget(self, action: #selector(didSelect(button:)), for: UIControlEvents.touchUpInside)
        buttonOne.addSubview(staticImage)
        self.addSubview(buttonOne)
        self.setConstraints(forButton: buttonOne, withEmoji: staticImage)
        staticImage.center = buttonOne.center
        
        Animoji.cool.set(intoView: animatorView)
        animatorView.startAnimating()
        
        let buttonTwo = UIButton(type: UIButtonType.custom)
        buttonTwo.addSubview(animatorView)
        animatorView.startAnimating()
        buttonTwo.tag = 2
        buttonTwo.isUserInteractionEnabled = true
        buttonTwo.translatesAutoresizingMaskIntoConstraints = false
        buttonTwo.addTarget(self, action: #selector(didSelect(button:)), for: UIControlEvents.touchUpInside)
        self.addSubview(buttonTwo)
        self.setConstraints(forButton: buttonTwo)
        
        indicatorCenterConstraint = NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: buttonOne, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([indicatorCenterConstraint!])
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(12)-[one]-(18)-[two]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["one": buttonOne, "two": buttonTwo]))
    }
    
    func setConstraints(forButton button: UIButton, withEmoji emojiView: UIImageView? = nil)
    {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 32))
        constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 32))
        constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
        if let imageView = emojiView
        {
            constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 24))
            constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 24))
            constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: button, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: button, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setConstraints(forIndicator indicatorView: UIView)
    {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 32))
        constraints.append(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2))
        constraints.append(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setConstraints(forSeparator separator: UIView)
    {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: separator, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: separator, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0.5))
        constraints.append(NSLayoutConstraint(item: separator, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func didSelect(button: UIButton)
    {
        if selectedButton?.tag == button.tag
        {
            return
        }
        
        self.selectedButton = button
        
        if self.selectedButton?.tag == 2
        {
            self.interactionDelegate?.showKeyboard(withType: ZKeyboardType.animoji)
        }
        else
        {
            self.interactionDelegate?.showKeyboard(withType: ZKeyboardType.emoji)
        }
    }
    
    func didSwitchColors()
    {
        self.backgroundColor = UIColor.tabBg
    }
}
