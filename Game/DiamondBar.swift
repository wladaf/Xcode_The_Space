//
//  DiamondBar.swift
//  Game
//
//  Created by Владислав Афанасьев on 25/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class DiamondBar
{
    var diamondBar: SKSpriteNode!
    var diamondIcon: SKSpriteNode!
    var diamondLabel: SKLabelNode!
    init(size: CGFloat, x: CGFloat, y: CGFloat)
    {
        diamondBar = SKSpriteNode()
        diamondBar.name = "diamondBar"
        diamondBar.position = CGPoint(x: x, y:  y)
        
        diamondIcon = SKSpriteNode(imageNamed: "DiamondIcon")
        diamondIcon.size = CGSize(width: size, height: size)
        diamondIcon.position = CGPoint(x: size*2/3, y:  -size/2)
        diamondIcon.zPosition = ZPositions.UI
        diamondBar.addChild(diamondIcon)
        
        diamondLabel = SKLabelNode()
        diamondLabel.position.y = diamondIcon.position.y
        diamondLabel.position.x = diamondIcon.position.x + size*2/3
        diamondLabel.text = "0"
        diamondLabel.verticalAlignmentMode = .Center
        diamondLabel.horizontalAlignmentMode = .Left
        diamondLabel.fontColor = UIColor.whiteColor()
        diamondLabel.fontSize = size
        diamondLabel.fontName = "Arial"
        diamondBar.addChild(diamondLabel)
        
    }
    
    
    func GetSprite()->SKSpriteNode
    {
        return diamondBar!
    }
    
    func UpdateDiamond(diamonds: Int)
    {
        diamondLabel.text = String(diamonds)
    }
}