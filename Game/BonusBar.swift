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
    init(image: String, size: CGSize, position: CGPoint)
    {
        icon = SKSpriteNode(imageNamed: image)
        icon.zPosition = ZPositions.UI
        icon.size = size
        icon.position.x = position.x + size.width/2
        icon.position.y = position.y - size.height/2
        SetOff()
        icon.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(Listen),
            SKAction.waitForDuration(0.25)])))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return icon!
    }
    
    func Listen()
    {
        var i: Int = 0
        SetOff()
        for x in player!.GetBonuses()
        {
            if x != ""
            {
                SetOn(x, index: i)
                i++
            }
        }
        
    }
    
    func SetOn(texture: String, index: Int)
    {
        icon.texture = SKTexture(imageNamed: texture)
        icon.hidden = false
    }
    
    func SetOff()
    {
        icon.hidden = true
    }
}


