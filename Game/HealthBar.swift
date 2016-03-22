//
//  HealthBar.swift
//  Game
//
//  Created by Владислав Афанасьев on 21/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class HealthBar
{
    var healthBarBack: SKSpriteNode!
    var healthBarFront: SKSpriteNode!
    var color: SKTexture!
    init(width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat, backTextureName: String, frontTextureName: String, colorTexture: SKTexture)
    {
        color = colorTexture
        healthBarBack = SKSpriteNode(imageNamed: "HealthBarBack")
        healthBarBack.name = "healthBar"
        healthBarBack.size = CGSize(width: width, height: height)
        healthBarBack.position = CGPoint(x: x, y:  y)
        healthBarBack.zPosition = ZPositions.UI
        DrawFrontLayer()
        healthBarBack.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(DrawFrontLayer),
            SKAction.waitForDuration(0.2)
            ])))
    }
    
    
    func GetSprite()->SKSpriteNode
    {
        return healthBarBack!
    }
    
    func DrawFrontLayer()
    {
        if healthBarFront != nil
        {
            healthBarFront.removeFromParent()
        }
        if player.health/player.maxFuel >= 0
        {
            let t = SKTexture(imageNamed: "HealthBarFront")
            let k = SKTexture(rect: CGRect(x: 0, y: 0, width: 1, height: player.health/player.maxHealth), inTexture: t)
            healthBarFront = SKSpriteNode(texture: k)
            healthBarFront.size.width =  healthBarBack.size.width
            healthBarFront.size.height = healthBarBack.size.height*player.health/player.maxHealth
            healthBarFront.position = CGPoint(x: 0, y: -(1-player.health/player.maxHealth)/2*healthBarBack.size.height)
            healthBarFront.colorBlendFactor = 1;
            healthBarFront.color = GetPixelColor(CGFloat(player.health)/CGFloat(player.maxHealth), color: color)
            healthBarBack.addChild(healthBarFront)
        }
    }
}
