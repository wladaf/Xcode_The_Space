//
//  Planet.swift
//  Game
//
//  Created by Владислав Афанасьев on 15/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import SpriteKit
import Foundation

class Planet {
    var planet: SKSpriteNode!
    init(planetType: Int, size: CGSize, position: CGPoint)
    {
        planet = planetGenerator.GetPlanet(planetType)
        planet.zPosition = ZPositions.Planet
        let scale = size.width/planet.size.width*(Rand.random(min: 0.1, max: 0.5))
        planet.setScale(scale)
        planet.position = position
        let ma = SKAction.moveToY(-planet.size.height/2, duration: NSTimeInterval(backgroundSpeed*2/3))
        let de = SKAction.removeFromParent()
        planet.runAction(SKAction.sequence([ma,de]))
    }
    
    func GetSprite()->SKSpriteNode
    {
        return planet
    }
}
