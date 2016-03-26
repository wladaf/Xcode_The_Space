//
//  ScoreLabel.swift
//  Game
//
//  Created by Владислав Афанасьев on 26/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class ScoreLabel
{
    var scoreLabel = SKLabelNode()
    init(x: CGFloat, y: CGFloat)
    {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = "0 km"
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: x, y: y)
        scoreLabel.zPosition = ZPositions.UI
        scoreLabel.horizontalAlignmentMode = .Center
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.name = "lbl_score"
    }
    
    func GetLabel()->SKLabelNode
    {
        return scoreLabel
    }
}