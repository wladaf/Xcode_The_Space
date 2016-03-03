//
//  PlanetGenerator.swift
//  Game
//
//  Created by Владислав Афанасьев on 03/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

struct PlanetType
{
    static let BlackHole: Int = 0
    static let AlivePlanet: Int = 1
    static let DeadPlanet: Int = 2
    static let Asteroid: Int = 3
}

struct color
{
    static var r: CGFloat = 0
    static var g: CGFloat = 0
    static var b: CGFloat = 0
}

class PlanetGenerator
{
    var planetNode: SKSpriteNode!

    
    func GetPlanet(type: Int)->SKSpriteNode
    {
        planetNode = SKSpriteNode(imageNamed: "PGBackLayer")
        switch type
        {
        case PlanetType.BlackHole:
            return SKSpriteNode(imageNamed: "")
        case PlanetType.Asteroid:
            return Asteroid()
        case PlanetType.AlivePlanet:
            return AlivePlanet()
        case PlanetType.DeadPlanet:
            return DeadPlanet()
        default:
            return SKSpriteNode(imageNamed: "")
        }
    }
    
    func Asteroid()->SKSpriteNode
    {
        CreateBackLayer()
        CreateShadow()
        return planetNode
    }
    
    func AlivePlanet()->SKSpriteNode
    {
        CreateBackLayer()
        CreateFrontLayer()
        CreateMiddleLayer()
        CreateShadow()
        return planetNode
    }
    
    func DeadPlanet()->SKSpriteNode
    {
        CreateBackLayer()
        CreateFrontLayer()
        CreateMiddleLayer()
        CreateShadow()
        return planetNode
    }
    
    func CreateBackLayer()
    {
        color.r = random(min: 0.1, max: 0.7)
        color.g = random(min: 0.1, max: 0.7)
        color.b = random(min: 0.1, max: 0.7)

        planetNode.color = UIColor.init(red: color.r, green: color.g, blue: color.b, alpha: 1)
        planetNode.colorBlendFactor = 1
    }
    
    func CreateFrontLayer()
    {
        let frontLayer = SKSpriteNode(imageNamed: "PGFrontLayer")
        frontLayer.colorBlendFactor = 1;
        frontLayer.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        let d = random(min: -0.1, max: 0.1)
        frontLayer.color = UIColor.init(red: color.r+d, green: color.g+d, blue: color.b+d, alpha: 1)
        planetNode.addChild(frontLayer)
    }
    
    func CreateMiddleLayer()
    {
        let middleLayer = SKSpriteNode(imageNamed: "PGMiddleLayer")
        middleLayer.colorBlendFactor = 1;
        middleLayer.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        let d = random(min: -0.1, max: 0.1)
        middleLayer.color = UIColor.init(red: color.r+d, green: color.g+d, blue: color.b+d, alpha: 1)
        planetNode.addChild(middleLayer)
    }
    
    func CreateShadow()
    {
        let shadow = SKSpriteNode(imageNamed: "PGShadow")
        planetNode.addChild(shadow)
    }
    
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
}
 