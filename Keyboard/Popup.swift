//
//  Popup.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/22/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit
import YYImage

internal class Popup: UIView
{
    private let magnifiedEmojiView = YYAnimatedImageView()
    
    private var ogWidth: CGFloat = 48
    private var ogHeight: CGFloat = 48
    private var magDimension: CGFloat = 72
    private let verticalSpacing: CGFloat = 20
    private weak var cell: UICollectionViewCell?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    init(forCell cell: UICollectionViewCell)
    {
        super.init(frame: CGRect.zero)
        
        self.cell = cell
        
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var imageDimension: CGFloat = magDimension
        
        if let animojiCell = cell as? AnimojiCollectionViewCell
        {
            self.ogWidth = 36
            self.ogHeight = 30
            self.magDimension = 60
            imageDimension = 48
            
            self.set(animoji: animojiCell.animoji)
        }
        else if let emojiCell = cell as? EmojiCollectionViewCell
        {
            self.ogWidth = 28
            self.ogHeight = 24
            self.magDimension = 46
            imageDimension = 28
            
            self.magnifiedEmojiView.image = emojiCell.imageView.image
            self.magnifiedEmojiView.contentMode = UIViewContentMode.scaleAspectFit
        }
        
        magnifiedEmojiView.translatesAutoresizingMaskIntoConstraints = false
        magnifiedEmojiView.layer.masksToBounds = true
        self.addSubview(magnifiedEmojiView)
        cell.contentView.superview?.superview?.superview?.superview?.superview?.addSubview(self)
        
        var xOffset: CGFloat = 0
        
        if let tableView = cell.superview as? UICollectionView
        {
            xOffset = tableView.contentOffset.x
        }
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: magDimension + ogHeight + verticalSpacing))
        constraints.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: magDimension))
        constraints.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -xOffset))
        
        constraints.append(NSLayoutConstraint(item: magnifiedEmojiView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: imageDimension))
        constraints.append(NSLayoutConstraint(item: magnifiedEmojiView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: imageDimension))
        constraints.append(NSLayoutConstraint(item: magnifiedEmojiView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 5 + (magDimension - imageDimension)/2))
        constraints.append(NSLayoutConstraint(item: magnifiedEmojiView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        NSLayoutConstraint.activate(constraints)
        
        self.setBackgroundLayer()
        
        cell.isHidden = true
    }
    
    func set(animoji: Animoji)
    {
        animoji.set(intoView: magnifiedEmojiView)
    }
    
    func setBackgroundLayer()
    {
        let sideSpacing: CGFloat = (magDimension - ogWidth)/2
        let totalHeight = magDimension + ogHeight + verticalSpacing
        let cornerRadius: CGFloat = 8
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: sideSpacing, y: totalHeight - cornerRadius))
        path.addLine(to: CGPoint(x: sideSpacing, y: totalHeight - ogHeight))
        
        path.addCurve(to: CGPoint(x: 0, y: magDimension), controlPoint1: CGPoint(x: sideSpacing, y: magDimension + 0.6 * sideSpacing), controlPoint2: CGPoint(x: 0, y: totalHeight - ogHeight - 0.6 * sideSpacing))
        
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * CGFloat(1.5), clockwise: true)
        path.addLine(to: CGPoint(x: magDimension - cornerRadius, y: 0))
        path.addArc(withCenter: CGPoint(x: magDimension - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi * CGFloat(1.5), endAngle: CGFloat(0), clockwise: true)
        path.addLine(to: CGPoint(x: magDimension, y: magDimension))
        
        path.addCurve(to: CGPoint(x: magDimension - sideSpacing, y: totalHeight - ogHeight), controlPoint1: CGPoint(x: magDimension, y: totalHeight - ogHeight - 0.6 * sideSpacing), controlPoint2: CGPoint(x: magDimension - sideSpacing, y: magDimension + 0.6 * sideSpacing))
        
        path.addLine(to: CGPoint(x: magDimension - sideSpacing, y: totalHeight - cornerRadius))
        
        path.addArc(withCenter: CGPoint(x: magDimension - sideSpacing - cornerRadius, y: totalHeight - cornerRadius), radius: cornerRadius, startAngle: CGFloat(0), endAngle: CGFloat.pi * CGFloat(0.5), clockwise: true)
        path.addLine(to: CGPoint(x: sideSpacing + cornerRadius, y: totalHeight))
        path.addArc(withCenter: CGPoint(x: sideSpacing + cornerRadius, y: totalHeight - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi * CGFloat(0.5), endAngle: CGFloat.pi, clockwise: true)
        path.close()
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = path.cgPath
        
        if UIColor.isDarkTheme
        {
            backgroundLayer.fillColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1).cgColor
        }
        else
        {
            backgroundLayer.fillColor = UIColor.keyboardBg.cgColor
        }
        
        backgroundLayer.position = CGPoint(x: 0, y: 0)
        backgroundLayer.shadowColor = UIColor.black.cgColor
        backgroundLayer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundLayer.shadowRadius = 8
        backgroundLayer.shadowOpacity = 0.2
        backgroundLayer.masksToBounds = false
        self.layer.insertSublayer(backgroundLayer, below: magnifiedEmojiView.layer)
    }
    
    override func removeFromSuperview()
    {
        self.cell?.isHidden = false
        super.removeFromSuperview()
    }
}
