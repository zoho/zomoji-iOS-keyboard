//
//  KeyboardCV.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/15/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit

internal class KeyboardCV: UICollectionView, UIInputViewAudioFeedback
{
    fileprivate var isAnimatable: Bool = false
    
    var parentDelegate: ZKeyboardDelegate?
    
    var interactionDelegate: InteractionDelegate?
    
    var currentSection: Int = 0
    
    var shouldIgnoreScrollOnce = false
    
    public var enableInputClicksWhenVisible: Bool
    {
        return true
    }
    
    convenience init(forType keyboardType: ZKeyboardType)
    {
        self.init(frame: CGRect.zero, collectionViewLayout: keyboardType.flowLayoutForKeyboard())
     
        self.showsHorizontalScrollIndicator = false
        
        isAnimatable = (keyboardType == ZKeyboardType.animoji)
        
        self.backgroundColor = UIColor.keyboardBg
        
        if isAnimatable
        {
            self.clipsToBounds = false
            self.layer.masksToBounds = false
            
            UsageMonitor.setTopAnimoji()
            
            self.register(AnimojiCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "AnimojiCell")
        }
        else
        {
            UsageMonitor.setTopEmoji()
            
            self.register(EmojiCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "EmojiCell")
        }
        
        self.delegate = self
        self.dataSource = self
    }
    
    func changeBg()
    {
        self.backgroundColor = UIColor.keyboardBg
    }
}

extension KeyboardCV: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if isAnimatable
        {
            return animojisArray.count
        }
        else
        {
            return emojisArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isAnimatable
        {
            return animojisArray[section].count
        }
        else
        {
            return emojisArray[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if isAnimatable
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimojiCell", for: indexPath) as! AnimojiCollectionViewCell
            cell.setImage(forAnimoji: animojisArray[indexPath.section][indexPath.row].0)
            cell.indexPath = indexPath
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCollectionViewCell
            cell.setImage(forEmoji: emojisArray[indexPath.section][indexPath.row])
            cell.indexPath = indexPath
            
            return cell
        }
    }
}

extension KeyboardCV: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        UIDevice.current.playInputClick()
        
        if let currentCell = collectionView.cellForItem(at: indexPath)
        {
            var resultDict: Dictionary<String,Any> = Dictionary()
            
            resultDict[zDictIsAnimoji] = self.isAnimatable
            
            if isAnimatable
            {
                let animojiType = animojisArray[indexPath.section][indexPath.row].0
                
                if let animojiCell = currentCell as? AnimojiCollectionViewCell
                {
                    if let image = animojiCell.animatorView.image
                    {
                        let data = UIImagePNGRepresentation(image)
                        resultDict[zDictImageData] = data
                    }
                }
                
                resultDict[zDictName] = animojiType.rawValue
                resultDict[zDictNumberOfFrames] = animojiType.framesForImage()
                resultDict[zDictStartingFrame] = animojiType.startingFrameForAnimation()
                resultDict[zDictStringEquivalent] = ":\(animojiType.rawValue)!:"
                
                UsageMonitor.selected(animoji: animojiType)
            }
            else
            {
                let emojiType = emojisArray[indexPath.section][indexPath.row]
                
                if let emojiCell = currentCell as? EmojiCollectionViewCell
                {
                    if let image = emojiCell.imageView.image
                    {
                        let data = UIImagePNGRepresentation(image)
                        resultDict[zDictImageData] = data
                    }
                }
                
                resultDict[zDictName] = emojiType.rawValue
                resultDict[zDictNumberOfFrames] = 1
                resultDict[zDictStringEquivalent] = ":\(emojiType.rawValue):"
                
                UsageMonitor.selected(emoji: emojiType)
            }
            
            parentDelegate?.zomojiWasSelected(withParams: resultDict)
        }
    }
}

extension KeyboardCV: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if self.shouldIgnoreScrollOnce
        {
            self.shouldIgnoreScrollOnce = false
            return
        }
        
        var visibleIndices: [Int] = []
        
        for cell in self.visibleCells
        {
            if let indexPath = self.indexPath(for: cell)
            {
                visibleIndices.append(indexPath.section)
            }
        }
        
        var sectionGroups = Set(visibleIndices).map
        {
            value in
            
            return visibleIndices.filter{ $0 == value }
        }
        
        sectionGroups = sectionGroups.sorted
        {
            (first, second) -> Bool in
            
            if first[0] < second[0]
            {
                return true
            }
            else
            {
                return false
            }
        }

        if sectionGroups.count > 1
        {
            if sectionGroups[0].count <= 5
            {
                sectionGroups.remove(at: 0)
            }
        }
        
        let firstSection = sectionGroups[0][0]
        
        self.interactionDelegate?.scrolledToSection(atIndex: firstSection, forKeyboard: isAnimatable ? ZKeyboardType.animoji: ZKeyboardType.emoji)
        self.currentSection = firstSection
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        guard isAnimatable
        else
        {
            return
        }
        
        if !decelerate
        {
            self.animateVisibleCells()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        guard isAnimatable
        else
        {
            return
        }
        
        self.animateVisibleCells()
    }
    
    func animateVisibleCells()
    {
        for cell in self.visibleCells
        {
            if let cell = cell as? AnimojiCollectionViewCell
            {
                if let indexPath = self.indexPath(for: cell)
                {
                    var animojiInfo = animojisArray[indexPath.section][indexPath.row]
                    
                    if animojiInfo.1
                    {
                        cell.animatorView.startAnimating()
                    }
                    
                    animojiInfo.1 = false
                    animojisArray[indexPath.section][indexPath.row] = animojiInfo
                }
            }
        }
    }
}

extension KeyboardCV
{
    func scroll(toIndex section: Int)
    {
        self.currentSection = section
        
        if let frameToScrollTo = self.layoutAttributesForItem(at: IndexPath(row: 0, section: section))?.frame
        {
            self.shouldIgnoreScrollOnce = true
            self.setContentOffset(CGPoint(x: frameToScrollTo.origin.x - 13, y: self.contentOffset.y), animated: false)
            
            if self.isAnimatable
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.animateVisibleCells()
                })
            }
        }
    }
}
