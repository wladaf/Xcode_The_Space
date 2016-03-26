//
//  TopBar.swift
//  Game
//
//  Created by Владислав Афанасьев on 25/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class TopBar
{
    private var width: CGFloat!
    private var height: CGFloat!
    
    var s: CGFloat!
    var k: CGFloat = 10
    var topBar: SKSpriteNode!
    init(image: String, size: CGSize)
    {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            s = 1
            break
        case .Pad:
            s = 2
            break
        default:
            s = 1
            break
        }
        width = size.width
        height = 50*s
        
        topBar = SKSpriteNode(imageNamed: image)
        topBar.zPosition = ZPositions.UI
        topBar.size.width = width
        topBar.size.height = height
        topBar.alpha = 1
        topBar.position.x = size.width/2
        topBar.position.y = size.height - height/2
        
        CreateFuelBar()
        CreateBonusBar()
        CreateHealthBar()
        CreateDiamondBar()
        CreatePauseButton()
        CreateScoreLabel()
    }
    
    func GetSprite()->SKSpriteNode
    {
        return topBar
    }
    
    func CreateFuelBar()
    {
        let fheight = height*3/4
        let fwidth = fheight*3/4
        UI.fuelBar = FuelBar(width: fwidth,
                             height: fheight,
                             x: width/2-fwidth/2-k,
                             y:  0,
                             backTextureName: "FuelBarBack", frontTextureName: "FuelBarFront", colorTexture: SKTexture(imageNamed: "PGRedToGreenColor"))
        
        topBar.addChild(UI.fuelBar.GetSprite())
    }
    
    func CreateHealthBar()
    {
        let bheight = height*3/4
        let bwidth = bheight
        UI.healthBar = HealthBar(width: bwidth,
                                 height: bheight,
                                 x: width/2-k-UI.fuelBar.GetSprite().size.width-bwidth/2,
                                 y:  0,
                                 backTextureName: "HealthBarBack",
                                 frontTextureName: "HealthBarFront",
                                 colorTexture: SKTexture(imageNamed: "PGRedToGreenColor"))
        topBar.addChild(UI.healthBar.GetSprite())
    }

    func CreateBonusBar()
    {
        UI.bonusBar = BonusBar(image: "BonusShield", size: CGSize(width: height/2, height: height/2), position: CGPoint(x: width/2, y: -height*2/3))
        topBar.addChild(UI.bonusBar.GetSprite())
    }
    
    func CreateDiamondBar()
    {
        UI.diamondBar = DiamondBar(size: height/2, x: -width/2, y: -height*2/3)
        topBar.addChild(UI.diamondBar.GetSprite())
    }
    
    func CreatePauseButton()
    {
        let psize = height*3/4
        UI.pauseButton = PauseButton(size: psize, x: -width/2 + k + psize/2, y: 0)
        topBar.addChild(UI.pauseButton.GetSprite())
    }
    
    func CreateScoreLabel(){
        UI.scoreLabel = ScoreLabel(x: 0, y: 0)
        topBar.addChild(UI.scoreLabel.GetLabel())
    }
}