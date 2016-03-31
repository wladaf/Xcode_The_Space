//
//  Menu.swift
//  Game
//
//  Created by Владислав Афанасьев on 29/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Menu
{
    var background: SKSpriteNode!
    var mainMenuButton: SKButton!
    var restartButton: SKButton!
    var bestLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    
    var width: CGFloat!
    var height: CGFloat!
    
    var bwidth: CGFloat!
    var bheight: CGFloat!
    var bspace: CGFloat!
    
    var best: CGFloat!
    var score: CGFloat!
    
    var position: CGPoint!
    init(size: CGSize, best: CGFloat, score: CGFloat, x: CGFloat, y: CGFloat)
    {
        position = CGPoint(x: x, y: y)
        self.width = size.width
        self.height = size.height
        self.best = best
        self.score = score
        CreateBackground()
        CreateRestartButton()
        CreateBestLabel()
        CreateScoreLabel()
        CreateMainMenuButton()
    }
    
    
    
    func CreateBackground()
    {
        background = SKSpriteNode(imageNamed: "MenuBack")
        background.name = "Menu"
        background.position = CGPoint(x: position.x, y: position.y)
        background.size = CGSize(width: width*5/6, height: width*5/6)
        background.zPosition = ZPositions.UI
        
        bwidth = background.size.width*5/6
        bheight = background.size.width/5
        bspace = bheight / 5
        
        
    }
    
    func CreateRestartButton()
    {
        restartButton = SKButton(size: CGSize(width: 0.9, height: 0.2), contextWidth: background.size.width,
                                 x: 0, y: -background.size.width/2 + bheight*3/2 + bspace * 2,
                                 imageName: "Button", name: "Restart")
        restartButton.SetText("Restart")
        background.addChild(restartButton.GetSprite())
        
    }
    
    func CreateScoreLabel()
    {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = "Score: " + String(Int(score)) + " km"

        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.fontSize = bheight/2
        scoreLabel.position = CGPoint(x: 0, y: bestLabel.position.y - bheight - bspace)
        scoreLabel.zPosition = ZPositions.UI
        scoreLabel.horizontalAlignmentMode = .Center
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.name = "lblScore"
        background.addChild(scoreLabel)
    }
    
    func CreateBestLabel()
    {
        bestLabel = SKLabelNode(fontNamed: "Arial")
        bestLabel.text = "Best: " + String(Int(best)) + " km"
        bestLabel.fontColor = SKColor.whiteColor()
        bestLabel.fontSize = bheight/2
        bestLabel.position = CGPoint(x: 0, y: background.size.width/2 - bheight/2 - bspace)
        bestLabel.zPosition = ZPositions.UI
        bestLabel.horizontalAlignmentMode = .Center
        bestLabel.verticalAlignmentMode = .Center
        bestLabel.name = "lblBest"
        background.addChild(bestLabel)

    }
    
    func CreateMainMenuButton()
    {
        mainMenuButton = SKButton(size: CGSize(width: 0.9, height: 0.2),
                                  contextWidth: background.size.width,
                                 x: 0, y: -background.size.width/2 + bheight/2 + bspace,
                                 imageName: "Button", name: "MainMenu")
        mainMenuButton.SetText("Menu")
        background.addChild(mainMenuButton.GetSprite())
    }
    
    func GetSprite()->SKSpriteNode
    {
        return background
    }
}