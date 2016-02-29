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
    
    init(Name: String)
    {
        Sprite = SKSpriteNode(imageNamed: Name)
    }
    
    func GetSprite()->SKSpriteNode
    {
        return Sprite!
    }
}