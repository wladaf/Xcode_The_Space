//
//  FuelBar.swift
//  Game
//
//  Created by Владислав Афанасьев on 11/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class FuelBar
{
    var fuelBarBack: SKSpriteNode!
    var fuelBarFront: SKSpriteNode!
    var color: SKTexture!
    init(width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat, backTextureName: String, frontTextureName: String, colorTexture: SKTexture)
    {
        color = colorTexture
        fuelBarBack = SKSpriteNode(imageNamed: "FuelBarBack")
        fuelBarBack.name = "fuelBar"
        fuelBarBack.size = CGSize(width: width, height: height)
        fuelBarBack.position = CGPoint(x: x, y:  y)
        fuelBarBack.zPosition = ZPositions.UI
        
        fuelBarBack.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(DrawFrontLayer),
            SKAction.waitForDuration(0.2),
            SKAction.runBlock(RemoveFrontLayer)
            ])))
    }
    
    
    func GetSprite()->SKSpriteNode
    {
        return fuelBarBack!
    }
    
    func RemoveFrontLayer()
    {
        if fuelBarFront != nil
        {
            fuelBarFront.removeFromParent()
        }
    }
    
    func DrawFrontLayer()
    {
        if player.fuel/player.maxFuel >= 0
        {
            let t = SKTexture(imageNamed: "FuelBarFront")
            let k = SKTexture(rect: CGRect(x: 0, y: 0, width: 1, height: player.fuel/player.maxFuel), inTexture: t)
            fuelBarFront = SKSpriteNode(texture: k)
            fuelBarFront.size.width =  fuelBarBack.size.width
            fuelBarFront.size.height = fuelBarBack.size.height*player.fuel/player.maxFuel*3/4
            fuelBarFront.position = CGPoint(x: 0, y: -(1-player.fuel/player.maxFuel)/2*fuelBarBack.size.height*3/4)
            fuelBarFront.colorBlendFactor = 1;
            fuelBarFront.color = GetPixelColor()
            fuelBarBack.addChild(fuelBarFront)
        }
    }
    
    func GetPixelColor()->UIColor
    {
        let imageDataProvider = CGImageGetDataProvider(color.CGImage())
        let pixelData = CGDataProviderCopyData(imageDataProvider);
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData);
        
        let x: Int = Int(CGFloat(player.fuel)/CGFloat(player.maxFuel)*99)
        let pixelInfo = 4 * x;
        
        let red: UInt8 = data[pixelInfo];
        let green: UInt8 = data[(pixelInfo + 1)];
        let blue: UInt8 = data[pixelInfo + 2];
        let alpha: UInt8 = data[pixelInfo + 3];
        
        return UIColor.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
    }
}