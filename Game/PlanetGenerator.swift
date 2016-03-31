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
let waterGradient = UIImage(named: "PGWaterColor")!
let groundGradient = UIImage(named: "PGGroundColor")!
let iceGradient = UIImage(named: "PGIceColor")!

struct PlanetType
{
    static let BlackHole: Int = 0
    static let AlivePlanet: Int = 1
    static let Star: Int = 2
    static let IcePlanet: Int = 3
    static let WaterPlanet: Int = 4
    static let DeadPlanet: Int = 5
    static let Asteroid: Int = 6
}

struct Count
{
    static let Layer0 = 1
    static let Layer1 = 1
    static let Layer2 = 1
    static let Layer3 = 1
    static let Clouds = 1
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
        case PlanetType.Star:
            return Star()
        case PlanetType.IcePlanet:
            return IcePlanet()
        case PlanetType.WaterPlanet:
            return WaterPlanet()
        default:
            return SKSpriteNode(imageNamed: "Moon")
        }
    }
    func BlackHole()->SKSpriteNode
    {
        let r = Rand.random(min:0, max: 2)
        planetNode = SKSpriteNode(imageNamed: "BlackHole\(r)")
        return planetNode
    }
    
    func Star()->SKSpriteNode
    {
        let r = Rand.random(min:0, max: 3)
        planetNode = SKSpriteNode(imageNamed: "Sun\(r)")
        return planetNode
    }

    
    func Asteroid()->SKSpriteNode
    {
        CreateLayer("PGLayer", firstIndex: 0, left: 0, right: 100, top: 18, bottom: 24, count: 1, image: groundGradient, colored: true, background: true)
        CreateLayer("PGLayer", firstIndex: 1, left: 0, right: 100, top: 18, bottom: 24, count: 1, image: groundGradient, colored: true, background:  false)
        CreateLayer("PGLayer", firstIndex: 2, left: 0, right: 100, top: 18, bottom: 24, count: 1, image: groundGradient, colored: true, background:  false)
        CreateShadow()
        return planetNode
    }
    
    func AlivePlanet()->SKSpriteNode
    {
        CreateLayer("PGLayer", firstIndex: 0, left: 0, right: 100, top: 12, bottom: 18, count: 1, image: groundGradient, colored: true, background: true)
        CreateWater()
        CreateClouds()
        CreateAtmosphere()
        CreateShadow()
        return planetNode
    }
    
    func IcePlanet()->SKSpriteNode
    {
        CreateLayer("PGLayer", firstIndex: 0, left: 0, right: 100, top: 0, bottom: 6, count: 1, image: iceGradient, colored: true, background: true)
        CreateLayer("PGLayer", firstIndex: 1, left: 0, right: 100, top: 0, bottom: 6, count: 1, image: iceGradient, colored: true, background:  false)
        CreateLayer("PGLayer", firstIndex: 2, left: 0, right: 100, top: 0, bottom: 6, count: 1, image: iceGradient, colored: true, background:  false)
        CreateClouds()
        CreateAtmosphere()
        CreateShadow()
        return planetNode
    }
    
    func WaterPlanet()->SKSpriteNode
    {
        CreateLayer("PGLayer", firstIndex: 0, left: 0, right: 100, top: 12, bottom: 18, count: 1, image: groundGradient, colored: true, background: true)
        CreateWater()
        CreateClouds()
        CreateAtmosphere()
        CreateShadow()
        return planetNode
    }
    
    func DeadPlanet()->SKSpriteNode
    {
        CreateLayer("PGLayer", firstIndex: 0, left: 0, right: 100, top: 6, bottom: 12, count: 1, image: groundGradient, colored: true, background:  true)
        CreateLayer("PGLayer", firstIndex: 1, left: 0, right: 100, top: 6, bottom: 12, count: 1, image: groundGradient, colored: true, background:  false)
        CreateLayer("PGLayer", firstIndex: 2, left: 0, right: 100, top: 6, bottom: 12, count: 1, image: groundGradient, colored: true, background:  false)
        CreateShadow()
        return planetNode
    }
    //////////////////////////////////////////////////////
    
    func CreateClouds()
    {
        let clouds = SKSpriteNode(imageNamed: "PGClouds\(random(min: 0, max: CGFloat(Count.Clouds)))")
        clouds.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        planetNode.addChild(clouds)
    }
    
    func CreateLayer(name: String, firstIndex: Int, left: Int, right: Int, top: Int, bottom: Int, count: CGFloat, image: UIImage, colored: Bool, background: Bool)
    {
        let layer = SKSpriteNode(imageNamed: "PGLayer\(firstIndex)-\(random(min: 0, max: count))")
        if colored{
            layer.colorBlendFactor = 1;
            layer.color = GetPixelColor((image.CGImage)!, width: right, bottom: bottom, top: top)
        }
        if background {
            planetNode = layer
        }
        else
        {
            layer.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
            planetNode.addChild(layer)
        }
    }
    
    func CreateWater()
    {
        let water = SKSpriteNode(imageNamed: "PGWater\(random(min: 0, max: CGFloat(Count.Water)))")
        water.colorBlendFactor = 1;
        water.zRotation = random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        water.color = GetPixelColor((waterGradient.CGImage)!, width: 100, bottom: 30, top: 0)
        planetNode.addChild(water)
    }
    
    func CreateAtmosphere()
    {
        let atmosphere = SKSpriteNode(imageNamed: "PGAtmosphere")
        atmosphere.colorBlendFactor = 1;
        atmosphere.color = GetPixelColor((waterGradient.CGImage)!, width: 100, bottom: 30, top: 0)
        atmosphere.alpha = 0.5
        planetNode.addChild(atmosphere)
    }
    
    func CreateShadow()
    {
        let shadow = SKSpriteNode(imageNamed: "PGShadow")
        planetNode.addChild(shadow)
    }
    
    func GetPixelColor(image: CGImage, width: Int, bottom: Int, top: Int)->UIColor
    {
        let imageDataProvider = CGImageGetDataProvider(image)
        let pixelData = CGDataProviderCopyData(imageDataProvider);
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData);
        
        let x: Int = Int(random(min: 0, max: CGFloat(width)))
        let y: Int = Int(random(min: CGFloat(top), max: CGFloat(bottom)))
        let pixelInfo: Int = ((width * y) + x) * numberOfColorComponents;
        
        let red: UInt8 = data[pixelInfo];
        let green: UInt8 = data[(pixelInfo + 1)];
        let blue: UInt8 = data[pixelInfo + 2];
        let alpha: UInt8 = data[pixelInfo + 3];
        
        return UIColor.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
}
 