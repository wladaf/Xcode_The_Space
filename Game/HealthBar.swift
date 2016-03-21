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
            healthBarFront.color = GetPixelColor()
            healthBarBack.addChild(healthBarFront)
        }
    }
    
    func GetPixelColor()->UIColor
    {
        let imageDataProvider = CGImageGetDataProvider(color.CGImage())
        let pixelData = CGDataProviderCopyData(imageDataProvider);
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData);
        
        let x: Int = Int(CGFloat(player.health)/CGFloat(player.maxHealth)*99)
        let pixelInfo = 4 * x;
        
        let red: UInt8 = data[pixelInfo];
        let green: UInt8 = data[(pixelInfo + 1)];
        let blue: UInt8 = data[pixelInfo + 2];
        let alpha: UInt8 = data[pixelInfo + 3];
        
        return UIColor.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
    }
}
