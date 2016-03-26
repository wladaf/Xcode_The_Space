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
    var meteorite: SKSpriteNode!
    let rotationSpeed: CGFloat!
    init(name: String, size: CGFloat, position: CGPoint, duration: NSTimeInterval, sceneSize: CGSize)
    {
        meteorite = SKSpriteNode(imageNamed: name)
        meteorite.name = "meteorite"
        meteorite.size  = CGSize(width: size,height: size)
        meteorite.position = position
        meteorite.zPosition = ZPositions.Meteorite
        
        meteorite.physicsBody = SKPhysicsBody(circleOfRadius: size/2)
        meteorite.physicsBody?.dynamic = true
        meteorite.physicsBody?.categoryBitMask = PhysicsCategory.Meteorite
        meteorite.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        meteorite.physicsBody?.collisionBitMask = PhysicsCategory.None
        meteorite.physicsBody?.allowsRotation = true
        
        rotationSpeed = Rand.random(min:0.5,max: 2.5)
        let ra = SKAction.rotateByAngle(1, duration: NSTimeInterval(rotationSpeed))
        var ma = SKAction()
        //let ma = SKAction.moveTo(CGPoint(x: meteorite.position.x + Rand.random(min: -sceneSize.width/10, max: sceneSize.width/10), y:-meteorite.frame.height/2), duration: duration)
        let k = Rand.random(min: -sceneSize.width/10, max: sceneSize.width/10)
        if meteorite.position.x + k >= 0 && meteorite.position.x + k <= sceneSize.width
        {
            ma = SKAction.moveTo(CGPoint(x: meteorite.position.x + Rand.random(min: -sceneSize.width/10, max: sceneSize.width/10), y:-meteorite.frame.height/2), duration: duration)
        }
        else
        {
            ma = SKAction.moveTo(CGPoint(x: meteorite.position.x, y:-meteorite.frame.height/2), duration: duration)
        }
        let da = SKAction.removeFromParent()
        meteorite.runAction(SKAction.repeatActionForever(ra))
        meteorite.runAction(SKAction.sequence([ma,da]))
        AddShadow("MeteoriteShadow")
    }
    
    func AddShadow(name: String)
    {
        let ra = SKAction.rotateByAngle(-1, duration: NSTimeInterval(rotationSpeed))
        let shadow = SKSpriteNode(imageNamed: name)
        shadow.size = meteorite.size
        shadow.position = CGPoint(x: 0,y: 0)
        shadow.zPosition = 1
        meteorite.addChild(shadow)
        shadow.runAction(SKAction.repeatActionForever(ra))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return meteorite!
    }
    
    func GetPhysicsBody()->SKPhysicsBody
    {
        return meteorite!.physicsBody!
    }
}
