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

let numberOfColorComponents: Int  = 4
var k: Int!
let waterGradient = UIImage(named: "PGWaterColor")
let groundGradient = UIImage(named: "PGGroundColor")

struct PlanetType
{
    static let BlackHole: Int = 0
    static let AlivePlanet: Int = 1
    static let DeadPlanet: Int = 2
    static let Asteroid: Int = 3
}

struct Count
{
    static let Layer0 = 1
    static let Layer1 = 1
    static let Layer2 = 1
    static let Layer3 = 1
    static let Water = 2
}

class PlanetGenerator
{
    var planetNode: SKSpriteNode!

    
    func GetPlanet(type: Int)->SKSpriteNode
    {
        switch type
        {
        case PlanetType.BlackHole:
            return BlackHole()
        case PlanetType.Asteroid:
            return Asteroid()
        case PlanetType.AlivePlanet:
            return AlivePlanet()
        case PlanetType.DeadPlanet:
            return DeadPlanet()
        default:
            return SKSpriteNode(imageNamed: "Moon")
        }
    }
    
    func BlackHole()->SKSpriteNode
    {
        planetNode = SKSpriteNode(imageNamed: "BlackHole")
        planetNode.zRotation = random(min:CGFloat(-M_PI), max: CGFloat(M_PI))
        return planetNode
    }

    
    func Asteroid()->SKSpriteNode
    {
        CreateLayer0(0)
        CreateShadow()
        return planetNode
    }
    
    func AlivePlanet()->SKSpriteNode
    {
        CreateLayer0(0)
        CreateLayer1()
        CreateLayer2()
//        CreateLayer3()
        CreateWater()
        CreateAtmosphere()
        CreateShadow()
        return planetNode
    }
    
    func DeadPlanet()->SKSpriteNode
    {
        CreateLayer0(0)
        CreateLayer1()
        CreateLayer2()
        CreateShadow()
        return planetNode
    }
    //////////////////////////////////////////////////////
    
    func CreateLayer0(layerIndex: Int)
    {
        planetNode = SKSpriteNode(imageNamed: "PGLayer0-\(layerIndex)")
        planetNode.color = GetPixelColor((groundGradient?.CGImage)!, width: 100, heigth: 6, start: 6)
        planetNode.colorBlendFactor = 1
    }
    
    func CreateLayer1()
    {
        let layer1 = SKSpriteNode(imageNamed: "PGLayer1-\(random(min: 0, max: CGFloat(Count.Layer1)))")
        layer1.colorBlendFactor = 1;
        layer1.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        layer1.color = GetPixelColor((groundGradient?.CGImage)!, width: 100, heigth: 6, start: 12)
        planetNode.addChild(layer1)
    }
    
    func CreateLayer2()
    {
        let layer2 = SKSpriteNode(imageNamed: "PGLayer2-\(random(min: 0, max: CGFloat(Count.Layer2)))")
        layer2.colorBlendFactor = 1;
        layer2.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        layer2.color = GetPixelColor((groundGradient?.CGImage)!, width: 100, heigth: 6, start: 0)
        planetNode.addChild(layer2)
    }
    
    func CreateLayer3()
    {
        let layer3 = SKSpriteNode(imageNamed: "PGLayer3-\(random(min: 0, max: CGFloat(Count.Layer3)))")
        layer3.colorBlendFactor = 1;
        layer3.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        layer3.color = GetPixelColor((groundGradient?.CGImage)!, width: 100, heigth: 18, start: 0)
        planetNode.addChild(layer3)
    }
    
    func CreateWater()
    {
        let water = SKSpriteNode(imageNamed: "PGWater\(random(min: 0, max: CGFloat(Count.Water)))")
        water.colorBlendFactor = 1;
        water.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        water.color = GetPixelColor((waterGradient?.CGImage)!, width: 100, heigth: 30, start: 0)
        planetNode.addChild(water)
    }
    
    func CreateAtmosphere()
    {
        let atmosphere = SKSpriteNode(imageNamed: "PGAtmosphere")
        atmosphere.colorBlendFactor = 1;
        atmosphere.color = GetPixelColor((waterGradient?.CGImage)!, width: 100, heigth: 30, start: 0)
        atmosphere.alpha = 0.5
        planetNode.addChild(atmosphere)
    }
    
    func GetPixelColor(image: CGImage, width: Int, heigth: Int, start: Int)->UIColor
    {
        let imageDataProvider = CGImageGetDataProvider(image)
        let pixelData = CGDataProviderCopyData(imageDataProvider);
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData);
        
        let x: Int = Int(random(min: 0, max: CGFloat(width)))
        let y: Int = Int(random(min: CGFloat(start), max: CGFloat(heigth+start)))
        let pixelInfo: Int = ((width * y) + x) * numberOfColorComponents;
        
        let red: UInt8 = data[pixelInfo];
        let green: UInt8 = data[(pixelInfo + 1)];
        let blue: UInt8 = data[pixelInfo + 2];
        let alpha: UInt8 = data[pixelInfo + 3];
        
        return UIColor.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
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
 