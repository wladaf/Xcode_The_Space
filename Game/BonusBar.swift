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
    var icon = [SKSpriteNode]()
    var height: CGFloat!
    var bonusBar: SKSpriteNode!
    init(image: String, size: CGSize, position: CGPoint)
    {
        bonusBar = SKSpriteNode()
        bonusBar.zPosition = ZPositions.UI
        bonusBar.position.x = position.x - size.width*2/3
        bonusBar.position.y = position.y - size.height/2
        height = size.height
        for i in 0..<Int(BonusType.count)
        {
            icon.append(SKSpriteNode(imageNamed: image))
            icon[i] = SKSpriteNode(imageNamed: image)
            icon[i].zPosition = ZPositions.UI
            icon[i].size = size
//            icon[i].position.x = position.x + size.width/2
//            icon[i].position.y = position.y - size.height/2 - CGFloat(i)*height
            //icon[i].position.x = 0
           // icon[i].position.y = -CGFloat(i)*height
            icon[i].position.x = -CGFloat(i)*(height+height/4)
            icon[i].position.y = 0
            
            bonusBar.addChild(icon[i])
        }
        SetOff()
        bonusBar.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(Listen),
            SKAction.waitForDuration(0.1)])))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return bonusBar
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
                i += 1
            }
        }
        
    }
    
    func SetOn(texture: String, index: Int)
    {
        icon[index].texture = SKTexture(imageNamed: texture)
        icon[index].hidden = false
    }
    
    func SetOff()
    {
        for x in icon
        {
            x.hidden = true
        }
    }
}


