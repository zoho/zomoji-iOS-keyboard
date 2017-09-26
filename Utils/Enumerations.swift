//
//  Enumerations.swift
//  ZKeyboard
//
//  Created by Vijay Sankar S on 9/15/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import UIKit
import YYImage

internal enum ZKeyboardType
{
    case emoji, animoji
    
    func flowLayoutForKeyboard() -> UICollectionViewFlowLayout
    {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.footerReferenceSize = CGSize(width: 20, height: 100)
        flowLayout.headerReferenceSize = CGSize(width: 15, height: 100)
        
        if self == ZKeyboardType.emoji
        {
            flowLayout.sectionInset = UIEdgeInsetsMake(12, 0, 12, 0)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            flowLayout.estimatedItemSize = CGSize(width: 28, height: 28)
            flowLayout.itemSize = CGSize(width: 28, height: 28)
        }
        else
        {
            flowLayout.sectionInset = UIEdgeInsetsMake(12, 0, 6, 0)
            flowLayout.minimumInteritemSpacing = 3
            flowLayout.minimumLineSpacing = 3
            flowLayout.estimatedItemSize = CGSize(width: 48, height: 48)
            flowLayout.itemSize = CGSize(width: 48, height: 48)
        }
        
        return flowLayout
    }
}


enum Emoji: String
{
    case angry = "angry"
    case anxious = "anxious"
    case awe = "awe"
    case blush = "blush"
    case bored = "bored"
    case cool = "cool"
    case curious = "curious"
    case doubt = "doubt"
    case evil = "evil"
    case facepalm = "facepalm"
    case faint = "faint"
    case feelingWarm = "feeling-warm"
    case feelingCold = "feeling-cold"
    case grinning = "grinning"
    case happy = "happy"
    case headache = "headache"
    case idea = "idea"
    case injured = "injured"
    case jealous = "jealous"
    case joy = "joy"
    case keepQuiet = "keep-quiet"
    case love = "love"
    case neutral = "neutral"
    case peace = "peace"
    case razz = "razz"
    case relaxed = "relaxed"
    case sad = "sad"
    case search = "search"
    case sick = "sick"
    case sleepy = "sleepy"
    case smile = "smile"
    case smirk = "smirk"
    case stressedOut = "stressed-out"
    case surprise = "surprise"
    case tensed = "tensed"
    case thinking = "thinking"
    case tired = "tired"
    case upset = "upset"
    case wink = "wink"
    case worry = "worry"
    case yuck = "yuck"
    case yummy = "yummy"
    case biceps = "biceps"
    case byeBye = "bye-bye"
    case clap = "clap"
    case fist = "fist"
    case namaste = "namaste"
    case raisingHand = "raising-hand"
    case superb = "super"
    case thumbsdown = "thumbsdown"
    case thumbsup = "thumbsup"
    case victory = "victory"
    case yoyo = "yoyo"
    case birthday = "birthday"
    case champagne = "champagne"
    case christmasTree = "christmas-tree"
    case eidMubarak = "eid-mubarak"
    case fireworks = "fireworks"
    case giftBox = "gift-box"
    case kaaba = "kaaba"
    case newYear = "new-year"
    case party = "party"
    case santaHat = "santa-hat"
    case coffeeCup = "coffee-cup"
    case food = "food"
    case chicken = "chicken"
    case fire = "fire"
    case fireExtinguisher = "fire-extinguisher"
    case firstAidBox = "first-aid-box"
    case medicine = "medicine"
    case poop = "poop"
    case peanuts = "peanuts"
    case refugeeOlympicTeam = "refugee-olympic-team"
    case target = "target"
    case task = "task"
    case report = "report"
    case bug = "bug"
    case milestone = "milestone"
    case calendar = "calendar"
    case security = "security"
    case processor = "processor"
    case laptop = "laptop"
    case server = "server"
    case badminton = "badminton"
    case baseball = "baseball"
    case basketball = "basketball"
    case chess = "chess"
    case cricket = "cricket"
    case flag = "flag"
    case foosball = "foosball"
    case football = "football"
    case golf = "golf"
    case hockey = "hockey"
    case snooker = "snooker"
    case tableTennis = "table-tennis"
    case tennis = "tennis"
    case volleyball = "volleyball"
    case goldMedal = "gold-medal"
    case silverMedal = "silver-medal"
    case bronzeMedal = "bronze-medal"
    case breakBoy = "break-boy"
    case breakGirl = "break-girl"
    case singing = "singing"
    case manDancing = "man-dancing"
    case manCycling = "man-cycling"
    case manRunning = "man-running"
    case manSwimming = "man-swimming"
    case womanDancing = "woman-dancing"
    case womanCycling = "woman-cycling"
    case womanRunning = "woman-running"
    case womanSwimming = "woman-swimming"
    case yoga = "yoga"
    case archer = "archer"
    case boxer = "boxer"
    case badmintonPlayer = "badminton-player"
    case basketballPlayer = "basketball-player"
    case batsman = "batsman"
    case batter = "batter"
    case bowler = "bowler"
    case canoeing = "canoeing"
    case chessPlayer = "chess-player"
    case discusThrow = "discus-throw"
    case diver = "diver"
    case equestrian = "equestrian"
    case fencer = "fencer"
    case footballPlayer = "football-player"
    case femaleTennisPlayer = "female-tennis-player"
    case femaleTabletennisPlayer = "female-tabletennis-player"
    case femaleVolleyballPlayer = "female-volleyball-player"
    case golfer = "golfer"
    case gymnast = "gymnast"
    case hockeyPlayer = "hockey-player"
    case hammerThrow = "hammer-throw"
    case hurdler = "hurdler"
    case javelinThrow = "javelin-throw"
    case judo = "judo"
    case longJump = "long-jump"
    case poleVault = "pole-vault"
    case athlete = "athlete"
    case rhythmicGymnastics = "rhythmic-gymnastics"
    case shooter = "shooter"
    case shotputThrow = "shotput-throw"
    case highJump = "high-jump"
    case karate = "karate"
    case maleTabletennisPlayer = "male-tabletennis-player"
    case maleVolleyballPlayer = "male-volleyball-player"
    case maleTennisPlayer = "male-tennis-player"
    case pitcher = "pitcher"
    case snookerPlayer = "snooker-player"
    case weightlifting = "weightlifting"
    case wrestling = "wrestling"
    case bicycle = "bicycle"
    case sportsBike = "sports-bike"
    case cruiserBike = "cruiser-bike"
    case motorScooter = "motor-scooter"
    case car = "car"
    case taxi = "taxi"
    case bus = "bus"
    case train = "train"
    case policeCar = "police-car"
    case ambulance = "ambulance"
    case fireEngine = "fire-engine"
    case aeroplane = "aeroplane"
    case passengerShip = "passenger-ship"
    case parking = "parking"
    case cafeteria = "cafeteria"
    case garden = "garden"
    case playground = "playground"
    case home = "home"
    case office = "office"
    case library = "library"
    case auditorium = "auditorium"
    case shop = "shop"
    case parcel = "parcel"
    case pharmacy = "pharmacy"
    case gym = "gym"
    case globeAmerica = "globe-america"
    case globeEurope = "globe-europe"
    case globeAsia = "globe-asia"
    
    func image() -> UIImage?
    {
        let image = UIImage(named: "Emoji/" + self.rawValue)
        return image
    }
}

enum Animoji: String
{
    case  angry = "angry"
    case  anxious = "anxious"
    case  awe = "awe"
    case  blush = "blush"
    case  bored = "bored"
    case  cool = "cool"
    case  curious = "curious"
    case  doubt = "doubt"
    case  evil = "evil"
    case  facepalm = "facepalm"
    case  faint = "faint"
    case  feelingWarm = "feeling-warm"
    case  feelingCold = "feeling-cold"
    case  grinning = "grinning"
    case  happy = "happy"
    case  headache = "headache"
    case  idea = "idea"
    case  injured = "injured"
    case  jealous = "jealous"
    case  joy = "joy"
    case  keepQuiet = "keep-quiet"
    case  love = "love"
    case  neutral = "neutral"
    case  peace = "peace"
    case  razz = "razz"
    case  relaxed = "relaxed"
    case  sad = "sad"
    case  search = "search"
    case  sick = "sick"
    case  sleepy = "sleepy"
    case  smile = "smile"
    case  smirk = "smirk"
    case  stressedOut = "stressed-out"
    case  surprise = "surprise"
    case  tensed = "tensed"
    case  thinking = "thinking"
    case  tired = "tired"
    case  upset = "upset"
    case  wink = "wink"
    case  worry = "worry"
    case  yuck = "yuck"
    case  yummy = "yummy"
    case  biceps = "biceps"
    case  byeBye = "bye-bye"
    case  clap = "clap"
    case  fist = "fist"
    case  namaste = "namaste"
    case  raisingHand = "raising-hand"
    case  superb = "super"
    case  thumbsdown = "thumbsdown"
    case  thumbsup = "thumbsup"
    case  victory = "victory"
    case  yoyo = "yoyo"
    case  birthday = "birthday"
    case  christmasTree = "christmas-tree"
    case  coffeeCup = "coffee-cup"
    case  eidMubarak = "eid-mubarak"
    case  fireworks = "fireworks"
    case  food = "food"
    case  giftBox = "gift-box"
    case  kaaba = "kaaba"
    case  newYear = "new-year"
    case  party = "party"
    case  santaHat = "santa-hat"
    case  fire = "fire"
    case  medicine = "medicine"
    case  poop = "poop"
    case  flag = "flag"
    case  badminton = "badminton"
    case  baseball = "baseball"
    case  basketball = "basketball"
    case  chess = "chess"
    case  cricket = "cricket"
    case  foosball = "foosball"
    case  football = "football"
    case  hockey = "hockey"
    case  snooker = "snooker"
    case  canoeing = "canoeing"
    case  tableTennis = "table-tennis"
    case  boxer = "boxer"
    case  highJump = "high-jump"
    case  discusThrow = "discus-throw"
    case  diver = "diver"
    case  athlete = "athlete"
    case  equestrian = "equestrian"
    case  fencer = "fencer"
    case  archer = "archer"
    case  hurdler = "hurdler"
    case  javelinThrow = "javelin-throw"
    case  judo = "judo"
    case  longJump = "long-jump"
    case  poleVault = "pole-vault"
    case  rhythmicGymnastics = "rhythmic-gymnastics"
    case  shotputThrow = "shotput-throw"
    
    func image() -> UIImage?
    {
        let image = UIImage(named: "Animoji/" + self.rawValue)
        return image
    }
    
    func framesForImage() -> Int
    {
        switch self
        {
        case Animoji.athlete:
            
            return 24;
            
        case Animoji.diver:
            
            return 65;
            
        case Animoji.discusThrow:
            
            return 105;
            
        case Animoji.equestrian:
            
            return 80;
            
        case Animoji.javelinThrow:
            
            return 109;
            
        case Animoji.judo:
            
            return 81;
            
        case Animoji.longJump:
            
            return 101;
            
        case Animoji.highJump:
            
            return 101;
            
        case Animoji.shotputThrow:
            
            return 111;
            
        case Animoji.fire:
            
            return 98;
            
        default:
            
            return 120
        }
    }
    
    func startingFrameForAnimation() -> Int
    {
        switch self
        {
            
        case Animoji.eidMubarak:
            
            return 81
            
        case Animoji.newYear:
            
            return 23
            
        case Animoji.party:
            
            return 107
            
        case Animoji.foosball:
            
            return 39
            
        case Animoji.tableTennis:
            
            return 80
            
        case Animoji.canoeing:
            
            return 38
            
        case Animoji.discusThrow:
            
            return 58
            
        case Animoji.diver:
            
            return 18
            
        case Animoji.equestrian:
            
            return 46
            
        case Animoji.fencer:
            
            return 49
            
        case Animoji.highJump:
            
            return 49
            
        case Animoji.hurdler:
            
            return 50
            
        case Animoji.javelinThrow:
            
            return 29
            
        case Animoji.judo:
            
            return 25
            
        case Animoji.longJump:
            
            return 44
            
        case Animoji.poleVault:
            
            return 48
            
        case Animoji.shotputThrow:
            
            return 5
            
        case Animoji.biceps:
            
            return 2
            
        case Animoji.clap:
            
            return 79
            
        case Animoji.fist:
            
            return 2
            
        case Animoji.angry:
            
            return 29
            
        case Animoji.awe:
            
            return 72
            
        case Animoji.cool:
            
            return 24
            
        case Animoji.facepalm:
            
            return 2
            
        case Animoji.faint:
            
            return 2
            
        case Animoji.happy:
            
            return 119
            
        case Animoji.joy:
            
            return 1
            
        case Animoji.neutral:
            
            return 116
            
        case Animoji.feelingWarm:
            
            return 4
            
        case Animoji.worry:
            
            return 4
            
        default:
            
            return 0
        }
    }
    
    func set(intoView animatorView: YYAnimatedImageView, shouldAutoAnimate: Bool = true)
    {
        var rects = [NSValue]()
        var duration = [NSNumber]()
        let frames = self.framesForImage()
        
        guard let image = self.image()
        else
        {
            return
        }
        
        let startingFrame = self.startingFrameForAnimation()
        
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
