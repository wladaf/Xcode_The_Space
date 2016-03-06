//
//  Random.swift
//  Game
//
//  Created by Владислав Афанасьев on 06/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//
import SpriteKit
import Foundation

class Rand{

    class func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    class func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}