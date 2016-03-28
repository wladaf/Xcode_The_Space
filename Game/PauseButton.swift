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
    
    var pauseTexture = "PauseButton"
    var defaultTexture = "PauseButtonDefault"
    var goTexture = "GoButton"
    init(size: CGFloat, x: CGFloat, y: CGFloat)
    {
        pauseButton = SKSpriteNode(imageNamed: defaultTexture)
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: size, height: size)
        pauseButton.position = CGPoint(x: x, y:  y)
        pauseButton.zPosition = ZPositions.UI
        pauseButton.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.1),])))
    }
    
    
    func GetSprite()->SKSpriteNode
    {
        return pauseButton!
    }
    
    func Click(context: GameScene)
    {
        if currentState == .Paused{
            context.setState(.Unpaused)
        }
        else
        if currentState == .Unpaused
        {
            context.setState(.Paused)
        }
    }
    
    func SetTexture()
    {
        switch currentState {
        case .Paused:
            pauseButton.texture = SKTexture(imageNamed:goTexture)
            break
        case .Unpaused:
            pauseButton.texture = SKTexture(imageNamed:pauseTexture)
            break
        case .Menu:
            pauseButton.texture = SKTexture(imageNamed:defaultTexture)
            break
        default:
            pauseButton.texture = SKTexture(imageNamed:defaultTexture)
        }
    }
    
}