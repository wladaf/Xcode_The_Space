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
    }
    
    func GetSprite()->SKSpriteNode
    {
        return sprite!
    }
    
    func GetPhysicsBody()->SKPhysicsBody
    {
        return sprite!.physicsBody!
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
            shield = SKSpriteNode(imageNamed: "Shield")
            shield.name = "shield"
            shield.size.width = sprite.size.width*1.5
            shield.size.height = sprite.size.width*1.5
            shield.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"ShieldColider"), size: shield.size)
            shield.position = CGPoint(x: 0, y: sprite.size.height/4)
            shield.physicsBody?.dynamic = true
            shield.physicsBody?.categoryBitMask = PhysicsCategory.Bonus
            shield.physicsBody?.contactTestBitMask = PhysicsCategory.Meteorite
            shield.physicsBody?.collisionBitMask = PhysicsCategory.None
            shield.physicsBody?.usesPreciseCollisionDetection = true
            sprite.addChild(shield)
            
            //let aa = SKAction.fadeOutWithDuration(1)
            let ra = SKAction.sequence([
                SKAction.waitForDuration(8),
                SKAction.fadeOutWithDuration(2),
                SKAction.runBlock(ShieldOff)
                ])
            //shield.runAction(SKAction.group([aa,ra]))
            shield.runAction(ra)
            
        }
    }
    
    func ShieldOff()
    {
        shieldIsOn = false;
        shield.removeFromParent()
       
    }
}