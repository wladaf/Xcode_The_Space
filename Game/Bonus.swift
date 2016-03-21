//
//  Bonus.swift
//  Game
//
//  Created by Владислав Афанасьев on 06/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit

class Bonus{
    let bonus: SKSpriteNode!
    
    init(type: Int, sceneSize: CGSize, duration: NSTimeInterval)
    {
        switch type
        {
        case BonusType.shield:
            bonus = SKSpriteNode(imageNamed: BonusType.shieldS)
            bonus.name = BonusType.shieldS
            break
        case BonusType.fuel:
            bonus = SKSpriteNode(imageNamed: BonusType.fuelS)
            bonus.name = BonusType.fuelS
            break
        case BonusType.health:
            bonus = SKSpriteNode(imageNamed: BonusType.healthS)
            bonus.name = BonusType.healthS
            break
        default:
            bonus = SKSpriteNode(imageNamed: "BonusShield")
            bonus.name = "bonusShield"
            break
        }
        
        bonus.size = CGSize(width: sceneSize.width/10, height: sceneSize.width/10)
        bonus.position = CGPoint(x: Rand.random(min: 0, max: sceneSize.width), y: sceneSize.height + bonus.size.width/2)
        bonus.physicsBody = SKPhysicsBody(circleOfRadius: bonus.size.width/2)
        bonus.zPosition = ZPositions.Bonus
        bonus.physicsBody?.dynamic = true
        bonus.physicsBody?.categoryBitMask = PhysicsCategory.Bonus
        bonus.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        bonus.physicsBody?.collisionBitMask = PhysicsCategory.Meteorite | PhysicsCategory.Fuel
        bonus.physicsBody?.usesPreciseCollisionDetection = true
        bonus.physicsBody?.allowsRotation = true
        
        //let ra = SKAction.rotateByAngle(1, duration: NSTimeInterval(1.5))
        let ma = SKAction.moveTo(CGPoint(x: bonus.position.x + Rand.random(min: -sceneSize.width/10, max: sceneSize.width/10), y:-bonus.frame.height/2), duration: duration)
        
        let da = SKAction.removeFromParent()
        //bonus.runAction(SKAction.repeatActionForever(ra))
        bonus.runAction(SKAction.sequence([ma,da]))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return bonus!
    }
    
    func GetPhysicsBody()->SKPhysicsBody
    {
        return bonus!.physicsBody!
    }
}
