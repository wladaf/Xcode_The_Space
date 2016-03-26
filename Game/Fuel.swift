//
//  Fuel.swift
//  Game
//
//  Created by Владислав Афанасьев on 14/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Fuel
{
    let fuel: SKSpriteNode!
    init(size: CGSize)
    {
        fuel = SKSpriteNode(imageNamed: "Fuel")
        fuel.name = "fuel"
        fuel.size = CGSize(width: size.width/18, height: size.width/12)
        fuel.position = CGPoint(x: Rand.random(min: 0, max: size.width), y: size.height + fuel.size.width/2)
        fuel.physicsBody = SKPhysicsBody(rectangleOfSize: fuel.size)
        fuel.zPosition = ZPositions.Bonus
        fuel.physicsBody?.dynamic = true
        fuel.physicsBody?.categoryBitMask = PhysicsCategory.Fuel
        fuel.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        fuel.physicsBody?.collisionBitMask = PhysicsCategory.Meteorite | PhysicsCategory.Bonus
        fuel.physicsBody?.usesPreciseCollisionDetection = true
        fuel.physicsBody?.allowsRotation = true
        
        let ra = SKAction.rotateByAngle(1, duration: NSTimeInterval(Rand.random(min: 0.5, max: 1.5)))
        let ma = SKAction.moveTo(CGPoint(x: fuel.position.x + Rand.random(min: -size.width/10, max: size.width/10), y:-fuel.frame.height/2), duration: NSTimeInterval(meteoriteSpeed))
        
        let da = SKAction.removeFromParent()
        fuel.runAction(SKAction.repeatActionForever(ra))
        fuel.runAction(SKAction.sequence([ma,da]))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return fuel
        
    }
}