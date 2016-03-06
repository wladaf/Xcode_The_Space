//
//  Meteorite.swift
//  Game
//
//  Created by Владислав Афанасьев on 06/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import SpriteKit
import Foundation

class Meteorite {
    var sprite: SKSpriteNode!
    let rotationSpeed: CGFloat!
    init(name: String, size: CGFloat, position: CGPoint, duration: NSTimeInterval, sceneSize: CGSize)
    {
        sprite = SKSpriteNode(imageNamed: name)
        sprite.name = "meteorite"
        sprite.size  = CGSize(width: size,height: size)
        sprite.position = position
        sprite.zPosition = ZPositions.Meteorite
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: size/2)
        sprite.physicsBody?.dynamic = false
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Meteorite
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        rotationSpeed = Rand.random(min:0.5,max: 2.5)
        let ra = SKAction.rotateByAngle(1, duration: NSTimeInterval(rotationSpeed))
        let ma = SKAction.moveTo(CGPoint(x: sprite.position.x + Rand.random(min: -sceneSize.width/10, max: sceneSize.width/10), y:-sprite.frame.height/2), duration: duration)
        
        let da = SKAction.removeFromParent()
        sprite.runAction(SKAction.repeatActionForever(ra))
        sprite.runAction(SKAction.sequence([ma,da]))
    }
    
    func AddShadow(name: String)
    {
        let ra = SKAction.rotateByAngle(-1, duration: NSTimeInterval(rotationSpeed))
        let Shadow = SKSpriteNode(imageNamed: name)
        Shadow.size = sprite.size
        Shadow.position = CGPoint(x: 0,y: 0)
        Shadow.zPosition = 1
        sprite.addChild(Shadow)
        Shadow.runAction(SKAction.repeatActionForever(ra))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return sprite!
    }
    
    func GetPhysicsBody()->SKPhysicsBody
    {
        return sprite!.physicsBody!
    }
}
