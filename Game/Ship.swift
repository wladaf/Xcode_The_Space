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
    private let sprite: SKSpriteNode!
    var shieldIsOn = false
    var speed: CGFloat!
    var shield: SKSpriteNode!
    var fuel: CGFloat!
    var bonusMultiplier: CGFloat = 1
    var maxFuel:CGFloat = 30
    var fire: SKSpriteNode!
    private var health: CGFloat = 100
    
    init(ship: Dictionary<String, String>, sceneWidth: CGFloat, position: CGPoint)
    {
        sprite = SKSpriteNode(imageNamed: ship["name"]!)
        sprite.name = "player"
        let scale = CGFloat((ship["size"]! as NSString).doubleValue)
        //sprite.size = CGSize(width: sceneWidth*scale, height: sceneWidth*scale*2)
        sprite.setScale(scale*sceneWidth/sprite.size.width)
        
        bonusMultiplier = CGFloat((ship["bonusMultiplier"]! as NSString).doubleValue)
        
        maxFuel = CGFloat((ship["maxFuel"]! as NSString).doubleValue)
        
        health = CGFloat((ship["health"]! as NSString).doubleValue)
        
        speed = CGFloat((ship["speed"]! as NSString).doubleValue)
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "\(ship["name"]!)Colider"), size: sprite!.size)
        sprite.position = position
        sprite.zPosition = ZPositions.Player
        sprite.physicsBody?.dynamic = true
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Player
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Meteorite
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.None
        sprite.physicsBody?.usesPreciseCollisionDetection = true
        fuel = maxFuel
        CreateShield()
        
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
    
    func CreateFire()
    {
        fire =  SKSpriteNode(imageNamed: "Fire1")
        fire.position = CGPoint(x: 0, y: -sprite.size.height*5/6)
        fire.zPosition = ZPositions.Player-1
        sprite.addChild(fire)
        fire.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(1/30),
            SKAction.runBlock(FireAnimation)])))
    }
    
    func FireAnimation()
    {
        let r = Rand.random(min: 0, max: 3)
        fire.texture = SKTexture(imageNamed: "Fire"+String(r))
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
    
    func CreateShield()
    {
        shield = SKSpriteNode(imageNamed: "Shield")
        shield.name = "shield"
        shield.setScale(1/2)
        //shield.size.width = sprite.size.width*1.5
        //shield.size.height = sprite.size.width*1.5
        shield.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"ShieldColider"), size: shield.size)
        shield.position = CGPoint(x: 0, y: sprite.size.height/4)
        shield.physicsBody?.dynamic = true
        shield.physicsBody?.categoryBitMask = PhysicsCategory.Shield
        shield.physicsBody?.contactTestBitMask = PhysicsCategory.Meteorite
        shield.physicsBody?.collisionBitMask = PhysicsCategory.None
        shield.physicsBody?.usesPreciseCollisionDetection = true
        shield.alpha = 0
        sprite.addChild(shield)
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
//            shield = SKSpriteNode(imageNamed: "Shield")
//            shield.name = "shield"
//            //shield.size.width = sprite.size.width*1.5
//            //shield.size.height = sprite.size.width*1.5
//            shield.setScale(sprite.)
//            shield.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"ShieldColider"), size: shield.size)
//            shield.position = CGPoint(x: 0, y: sprite.size.height/4)
//            shield.physicsBody?.dynamic = true
//            shield.physicsBody?.categoryBitMask = PhysicsCategory.Bonus
//            shield.physicsBody?.contactTestBitMask = PhysicsCategory.Meteorite
//            shield.physicsBody?.collisionBitMask = PhysicsCategory.None
//            shield.physicsBody?.usesPreciseCollisionDetection = true
//            sprite.addChild(shield)
            shield.alpha=1
            let ra = SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(8*bonusMultiplier)),
                SKAction.fadeOutWithDuration(2),
                SKAction.runBlock(ShieldOff)
                ])
            shield.runAction(ra)
        }
    }
    
    func ShieldOff()
    {
        //shield.removeFromParent()
        shieldIsOn = false
        shield.alpha = 0
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