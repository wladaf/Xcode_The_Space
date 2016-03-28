//
//  SKButton.swift
//  Game
//
//  Created by Владислав Афанасьев on 26/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class SKButton
{
    var button: SKSpriteNode!
    var bText: SKLabelNode!
    init(size: CGSize, x: CGFloat, y: CGFloat, imageName: String)
    {
        button = SKSpriteNode(imageNamed: imageName)
        button.name = imageName
        button.size = CGSize(width: size.width, height: size.height)
        button.position = CGPoint(x: x, y:  y)
        button.zPosition = ZPositions.UI
        
        bText = SKLabelNode()
        bText.position = CGPoint(x: 0, y: 0)
        bText.name = imageName
        bText.zPosition = ZPositions.UI
        bText.fontName = "Arial"
        bText.fontSize = size.height/2
        bText.horizontalAlignmentMode = .Center
        bText.verticalAlignmentMode = .Center
        button.addChild(bText)
    }
    
    
    func GetSprite()->SKSpriteNode
    {
        return button!
    }
    
    func SetText(text: String)
    {
        bText.text = text
    }
    
    func SetAction(context: SKScene)
    {
        
    }
}