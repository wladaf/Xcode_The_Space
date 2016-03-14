//
//  BackgroundStar.swift
//  Game
//
//  Created by Владислав Афанасьев on 14/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class BackgroundStar
{
    let star: SKShapeNode!
    init(x: CGFloat, y: CGFloat, size: CGSize)
    {
        star = SKShapeNode(circleOfRadius: Rand.random(min:0.5, max: 1))
        star.position = CGPointMake(x, y)
        star.zPosition = ZPositions.Background
        star.strokeColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        star.fillColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        let ma = SKAction.moveToY(-star.frame.height/2, duration: NSTimeInterval(CGFloat(backgroundSpeed) * (star.position.y/size.height)))
        let da = SKAction.removeFromParent()
        star.runAction(SKAction.sequence([ma,da]))
    }
    
    func GetSprite()->SKShapeNode
    {
        return star
    }
}