//
//  CollectionViewCells.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/15/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit
import YYImage
import QuartzCore

internal class EmojiCollectionViewCell: UICollectionViewCell
{
    let imageView = UIImageView()
    private var longPressGR: UILongPressGestureRecognizer?
    private var popupInstance: Popup?
    var indexPath: IndexPath?
    
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
    
    private func initialise()
    {
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        self.contentView.addSubview(imageView)
        self.contentView.setShadow()
        
        longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(longPressGR:)))
        longPressGR?.allowableMovement = 50
        longPressGR?.minimumPressDuration = 0.4
        self.contentView.addGestureRecognizer(longPressGR!)
    }
    
    func setImage(forEmoji emoji: Emoji)
    {   
        if let image = emoji.image()
        {
            self.imageView.image = image
        }
    }
    
    @objc func longPressed(longPressGR: UILongPressGestureRecognizer)
    {
        if longPressGR.state == UIGestureRecognizerState.began
        {
            popupInstance = Popup(forCell: self)
        }
        else if longPressGR.state == UIGestureRecognizerState.cancelled || longPressGR.state == UIGestureRecognizerState.ended
        {
            if let popup = popupInstance
            {
                popup.removeFromSuperview()
                popupInstance = nil
            }
        }
    }
}

internal class AnimojiCollectionViewCell: UICollectionViewCell
{
    let animatorView = YYAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
    private var longPressGR: UILongPressGestureRecognizer?
    private var popupInstance: Popup?
    var animoji: Animoji!
    var indexPath: IndexPath?
    
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
    
    private func initialise()
    {   
        self.contentView.addSubview(animatorView)
        self.contentView.setShadow()
        
        longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(longPressGR:)))
        longPressGR?.allowableMovement = 50
        longPressGR?.minimumPressDuration = 0.4
        self.contentView.addGestureRecognizer(longPressGR!)
    }
    
    func setImage(forAnimoji animoji: Animoji)
    {
        self.animoji = animoji
        
        animoji.set(intoView: animatorView, shouldAutoAnimate: false)
    }
    
    @objc func longPressed(longPressGR: UILongPressGestureRecognizer)
    {
        if longPressGR.state == UIGestureRecognizerState.began
        {
            popupInstance = Popup(forCell: self)
        }
        else if longPressGR.state == UIGestureRecognizerState.cancelled || longPressGR.state == UIGestureRecognizerState.ended
        {
            if let popup = popupInstance
            {
                popup.removeFromSuperview()
                popupInstance = nil
            }
        }
    }
}
