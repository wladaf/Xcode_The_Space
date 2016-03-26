//
//  Diamond.swift
//  Game
//
//  Created by Владислав Афанасьев on 24/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import SpriteKit
import Foundation

class Diamond {
    var diamond: SKSpriteNode!
    let rotationSpeed: CGFloat!
    init(name: String, size: CGFloat, position: CGPoint, duration: NSTimeInterval, sceneSize: CGSize)
    {
        diamond = SKSpriteNode(imageNamed: name)
        diamond.name = "diamond"
        diamond.size  = CGSize(width: size,height: size)
        diamond.position = position
        diamond.zPosition = ZPositions.Meteorite
        
        diamond.physicsBody = SKPhysicsBody(circleOfRadius: size/2)
        diamond.physicsBody?.dynamic = true
        diamond.physicsBody?.categoryBitMask = PhysicsCategory.Meteorite
        diamond.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        diamond.physicsBody?.collisionBitMask = PhysicsCategory.None
        diamond.physicsBody?.allowsRotation = true
        
        rotationSpeed = Rand.random(min:0.5,max: 2.5)
        //let ra = SKAction.rotateByAngle(1, duration: NSTimeInterval(rotationSpeed))
        let ma = SKAction.moveTo(CGPoint(x: diamond.position.x + Rand.random(min: -sceneSize.width/10, max: sceneSize.width/10), y:-diamond.frame.height/2), duration: duration)
        
        let da = SKAction.removeFromParent()
        //diamond.runAction(SKAction.repeatActionForever(ra))
        diamond.runAction(SKAction.sequence([ma,da]))
        //AddShadow("MeteoriteShadow")
    }
    
    func AddShadow(name: String)
    {
        let ra = SKAction.rotateByAngle(-1, duration: NSTimeInterval(rotationSpeed))
        let shadow = SKSpriteNode(imageNamed: name)
        shadow.size = diamond.size
        shadow.position = CGPoint(x: 0,y: 0)
        shadow.zPosition = 1
        diamond.addChild(shadow)
        shadow.runAction(SKAction.repeatActionForever(ra))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return diamond!
    }
    
    func GetPhysicsBody()->SKPhysicsBody
    {
        return diamond!.physicsBody!
    }
}
