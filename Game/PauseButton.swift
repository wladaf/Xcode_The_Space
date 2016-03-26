//
//  PauseButton.swift
//  Game
//
//  Created by Владислав Афанасьев on 26/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class PauseButton
{
    var pauseButton: SKSpriteNode!
    init(size: CGFloat, x: CGFloat, y: CGFloat)
    {
        pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: size, height: size)
        pauseButton.position = CGPoint(x: x, y:  y)
        pauseButton.zPosition = ZPositions.UI
    }
    
    
    func GetSprite()->SKSpriteNode
    {
        return pauseButton!
    }
    
    func Click(context: SKScene)
    {
        if currentState == .Paused{
            currentState = State.Unpaused
            pauseButton.texture = SKTexture(imageNamed: "PauseButton")
//            for x in context.children{
//                x.paused=false
//            }
            context.paused=false
        }
        else
        if currentState == .Unpaused
        {
            currentState = .Paused
            pauseButton.texture = SKTexture(imageNamed: "GoButton")
//            for x in context.children{
//                x.paused=true
//            }
            context.paused=true
        }
    }
}