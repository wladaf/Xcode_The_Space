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
    var Sprite: SKSpriteNode?
    
    init(Name: String, Scale:CGFloat, Position: CGPoint)
    {
        Sprite = SKSpriteNode(imageNamed: Name)
        Sprite!.xScale = Scale
        Sprite!.yScale = Scale
        Sprite!.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "\(Name)Colider"), size: Sprite!.size)
        Sprite!.position = Position
        Sprite!.physicsBody?.dynamic = true
        Sprite!.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Sprite!.physicsBody?.contactTestBitMask = PhysicsCategory.Meteorite
        Sprite!.physicsBody?.collisionBitMask = PhysicsCategory.None
        Sprite!.physicsBody?.usesPreciseCollisionDetection = true
        Sprite!.physicsBody?.fieldBitMask = PhysicsCategory.None

    }
    
    func GetSprite()->SKSpriteNode
    {
        return Sprite!
    }
    
    
    
    func GetPhysicsBody()->SKPhysicsBody
    {
        return Sprite!.physicsBody!
    }
}