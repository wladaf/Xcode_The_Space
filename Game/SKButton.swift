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
    var xscale: CGFloat!
    var yscale: CGFloat!
    var button: SKSpriteNode!
    var bText: SKLabelNode!
    var image: SKSpriteNode!
    
    var bsize: CGSize!
    init(size: CGSize, contextWidth: CGFloat, x: CGFloat, y: CGFloat, imageName: String, name: String, image: String = "", slicing: Bool = true)
    {
        bsize = CGSize(width: contextWidth * size.width, height: contextWidth * size.height)
        button = SKSpriteNode(imageNamed: imageName)
        xscale = (contextWidth/button.size.width) * size.width
        yscale = (contextWidth/button.size.height) * size.height
        if slicing
        {
            button.centerRect = CGRectMake(24/160, 24/160, 112/160, 112/160)
        }
        button.xScale = xscale
        button.yScale = yscale
        button.name = name
        button.position = CGPoint(x: x, y:  y)
        button.zPosition = ZPositions.UI
        
        bText = SKLabelNode()
        bText.yScale = 1/yscale
        bText.xScale = 1/xscale
        bText.fontSize = size.height*contextWidth*2/3
        bText.position = CGPoint(x: 0, y: 0)
        bText.name = name
        bText.zPosition = ZPositions.UI
        bText.fontName = "Arial"
        bText.horizontalAlignmentMode = .Center
        bText.verticalAlignmentMode = .Center
        button.addChild(bText)
        SetImage(image, name: name)
    }
    
    
    func GetSprite()->SKSpriteNode
    {
        return button!
    }
    
    func SetText(text: String)
    {
        bText.text = text
    }
    
    func SetImage(imageN: String, name: String)
    {
        if imageN != ""
        {
            image = SKSpriteNode(imageNamed: imageN)
            image.name = name
            //let k = min(bsize.width, bsize.height)
            image.size = button.size
            //image.size.width /= xscale
            //image.yScale = k/image.size.height
            image.xScale = (yscale/xscale) //* (k/image.size.width)
            button.addChild(image)
        }
    }
}