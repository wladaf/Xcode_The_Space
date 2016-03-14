//
//  BonusBar.swift
//  Game
//
//  Created by Владислав Афанасьев on 14/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class BonusBar
{
    var icon: SKSpriteNode!
    var time: CGFloat!
    init(image: String, size: CGSize, position: CGPoint)
    {
        time = 8*player!.GetBonusMultiplier()+2
        
        icon = SKSpriteNode(imageNamed: image)
        icon.zPosition = ZPositions.UI
        icon.size = size
        icon.position.x = position.x + size.width/2
        icon.position.y = position.y - size.height/2
        SetOff()
    }
    
    func GetSprite()->SKSpriteNode
    {
        return icon!
    }
    
    func UpdateTime()
    {
        time = time - 1;
        if time <= 0
        {
            icon.removeAllActions()
            SetOff()
        }
    }
    
    func SetOn(texture: String, time: CGFloat)
    {
        self.time = time
        icon.texture = SKTexture(imageNamed: texture)
        icon.hidden = false
        icon.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(UpdateTime),
            SKAction.waitForDuration(1)])))
    }
    
    func SetOff()
    {
        icon.hidden = true
    }
}


