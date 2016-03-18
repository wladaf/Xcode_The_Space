//
//  Ship.swift
//  Game
//
//  Created by Владислав Афанасьев on 29/02/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import SpriteKit
import Foundation

class Ship{
    let sprite: SKSpriteNode!
    var shieldIsOn = false
    var shield: SKSpriteNode!
    var fuel: CGFloat!
    var bonusMultiplier: CGFloat = 1
    var maxFuel:CGFloat = 30
    var health: CGFloat = 100
    
    init(name: String, size: CGFloat, position: CGPoint)
    {
        sprite = SKSpriteNode(imageNamed: name)
        sprite.name = "player"
        sprite.size = CGSize(width: size, height: size*2)
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "\(name)Colider"), size: sprite!.size)
        sprite.position = position
        sprite.zPosition = ZPositions.Player
        sprite.physicsBody?.dynamic = true
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Player
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Meteorite
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.None
        sprite.physicsBody?.usesPreciseCollisionDetection = true
        fuel = maxFuel
    }
    
    func StartUseFuel()
    {
        sprite.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(0.2),
                SKAction.runBlock(DecreaseFuel)
                ])
            ))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return sprite!
    }
    
    func GetPhysicsBody()->SKPhysicsBody
    {
        return sprite!.physicsBody!
    }
    
    func GetBonusMultiplier()->CGFloat
    {
        return bonusMultiplier
    }
    
    func ShieldOn()
    {
        if shieldIsOn == true{
            ShieldOff()
            ShieldOn()
        }
        else
        {
            shieldIsOn = true
            shield = SKSpriteNode(imageNamed: "Shield2")
            shield.name = "shield"
            //shield.size.width = sprite.size.width*1.5
            //shield.size.height = sprite.size.width*1.5
            shield.size.width = sprite.size.width
            shield.size.height = sprite.size.height
            shield.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"Shield2"), size: shield.size)
            //shield.position = CGPoint(x: 0, y: sprite.size.height/4)
            shield.position = CGPoint(x: 0, y: 0)
            shield.physicsBody?.dynamic = true
            shield.physicsBody?.categoryBitMask = PhysicsCategory.Bonus
            shield.physicsBody?.contactTestBitMask = PhysicsCategory.Meteorite
            shield.physicsBody?.collisionBitMask = PhysicsCategory.None
            shield.physicsBody?.usesPreciseCollisionDetection = true
            sprite.addChild(shield)
            
            //let aa = SKAction.fadeOutWithDuration(1)
            let ra = SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(8*bonusMultiplier)),
                SKAction.fadeOutWithDuration(2),
                SKAction.runBlock(ShieldOff)
                ])
            //shield.runAction(SKAction.group([aa,ra]))
            shield.runAction(ra)
            
            
            
        }
    }
    
    func ShieldOff()
    {
        
        shield.removeFromParent()
        shieldIsOn = false;
       
    }
    
    func UseFuel(fuelCount: CGFloat)
    {
        fuel! += fuelCount
        if fuel > maxFuel
        {
            fuel! = maxFuel
        }
    }
    
    func DecreaseFuel()
    {
        if fuel > 0
        {
            fuel! -= 0.2
        }
    }
    
    func NoFuel()->Bool
    {
        return fuel <= 0 ? true : false
    }
}