//
//  ViewController.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/15/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit
import YYImage

class TestViewController: UIViewController, ZKeyboardDelegate
{
    let staticImage = UIButton(type: UIButtonType.custom)
    let animatorView = YYAnimatedImageView(frame: CGRect.zero)
    var isFirst = true
    var isDarkTheme = true
    var controller = KeyboardController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard isFirst
        else
        {
            return
        }
        
        isFirst = false
        
        staticImage.translatesAutoresizingMaskIntoConstraints = false
        staticImage.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(staticImage)
        staticImage.addTarget(self, action: #selector(endEditing), for: UIControlEvents.touchUpInside)
        
        animatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(animatorView)
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        textField()
        
        let viewsDict: [String: Any] = ["anim": animatorView, "static": staticImage]
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(140)-[anim(72)]-(20)-[static(32)]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsDict))
        constraints.append(NSLayoutConstraint(item: animatorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[anim(72)]", options: [], metrics: nil, views: viewsDict))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[static(32)]", options: [], metrics: nil, views: viewsDict))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func textField()
    {
        let keyboard = controller.keyboard(withDelegate: self)
        
        let tf = UITextField()
        tf.inputView?.autoresizingMask = []
        tf.inputView = keyboard
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Tap to present"
        tf.textAlignment = NSTextAlignment.center
        tf.layer.cornerRadius = 3
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        self.view.addSubview(tf)
        
        let button1 = UIButton(type: UIButtonType.system)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        button1.addTarget(self, action: #selector(endEditing), for: UIControlEvents.touchUpInside)
        button1.layer.cornerRadius = 3
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button1.setTitle("Tap to dismiss", for: UIControlState.normal)
        button1.tintColor = UIColor(red:0.75, green:0.75, blue:0.77, alpha:1.00)
        button1.layer.masksToBounds = true
        self.view.addSubview(button1)
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        button.addTarget(self, action: #selector(switchThemes), for: UIControlEvents.touchUpInside)
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("Switch Themes", for: UIControlState.normal)
        button.tintColor = UIColor(red:0.75, green:0.75, blue:0.77, alpha:1.00)
        button.layer.masksToBounds = true
        self.view.addSubview(button)
        
        let viewsDict: [String: Any] = ["tf": tf, "bt": button1, "bt2": button]
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(50)-[tf(30)]-(20)-[bt2(30)]", options: [], metrics: nil, views: viewsDict))
        constraints.append(NSLayoutConstraint(item: tf, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -5))
        constraints.append(NSLayoutConstraint(item: button1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: tf, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: tf, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[tf(150)]-(10)-[bt(==tf)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    @objc func endEditing()
    {
        self.view.endEditing(true)
    }
    
    @objc func switchThemes()
    {
        isDarkTheme = !isDarkTheme
        controller.switchTheme(isDark: isDarkTheme)
    }
    
    func zomojiWasSelected(withParams parameters: Dictionary<String,Any>)
    {
        if let isAnimatable = parameters[zDictIsAnimoji] as? Bool, isAnimatable
        {
            if let imageData = parameters[zDictImageData] as? Data
            {
                if let image = UIImage(data: imageData)
                {
                    let startingFrame = parameters[zDictStartingFrame] as? Int ?? 0
                    let frames = parameters[zDictNumberOfFrames] as? Int ?? 0
                    
                    self.setAnimoji(withImage: image, intoView: self.animatorView, withFrames: frames, andStartingFrame: startingFrame)
                }
            }
        }
        else
        {
            if let imageData = parameters[zDictImageData] as? Data
            {
                if let image = UIImage(data: imageData)
                {
                    self.staticImage.setImage(image, for: UIControlState.normal)
                }
            }
        }
    }
    
    func backspaceWasPressed()
    {
        
    }
}

extension TestViewController
{
    func setAnimoji(withImage image: UIImage, intoView animatorView: YYAnimatedImageView, withFrames frameCount: Int, andStartingFrame startingFrame: Int, shouldAutoAnimate: Bool = true)
    {
        var rects = [NSValue]()
        var duration = [NSNumber]()
        let frames = frameCount
        
        let startingFrame = startingFrame
        
        for i in startingFrame..<frames
        {
            let rect = CGRect(x: 0, y: image.size.height/CGFloat(frames) * CGFloat(i), width: image.size.width, height: image.size.height/CGFloat(frames))
            rects.append(NSValue(cgRect: rect))
            duration.append(NSNumber(value: 0.035))
        }
        
        for i in 0..<startingFrame
        {
            let rect = CGRect(x: 0, y: image.size.height/CGFloat(frames) * CGFloat(i), width: image.size.width, height: image.size.height/CGFloat(frames))
            rects.append(NSValue(cgRect: rect))
            duration.append(NSNumber(value: 0.035))
        }
        
        let sprite = YYSpriteSheetImage(spriteSheetImage: image, contentRects: rects, frameDurations: duration, loopCount: shouldAutoAnimate.loopCount())
        animatorView.autoPlayAnimatedImage = shouldAutoAnimate
        animatorView.image = sprite
    }
}
