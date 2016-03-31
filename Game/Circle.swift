//
//  Circle.swift
//  Game
//
//  Created by Владислав Афанасьев on 28/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Circle{
    var circledx: CGFloat = 0
    var circledy: CGFloat = 0
    var circle: SKSpriteNode!
    init(){
        circle = SKSpriteNode(imageNamed: "Circle")
        circle.name = "circle"
        circle.size = CGSize(width: 60, height: 60)
        circle.position.x = 0
        circle.position.y = 0
        circle.zPosition = ZPositions.UICircle
        circle.hidden = true
    }
    
    func GetSprite()->SKSpriteNode
    {
        return circle
    }
    
    func SetPosition(position: CGPoint)
    {
        circle.position = position
    }
    
    func SetHeddin(value: Bool)
    {
        circle.hidden = value
    }
    
    func MoveTo(location: CGPoint)
    {
        circle.runAction(SKAction.moveTo(location, duration: 0.05))
    }
    
    func UpdateDPosition(touch: UITouch, context: GameScene)
    {
        let location = touch.locationInNode(context)
        circledx = player.GetSprite().position.x - location.x
        circledy = player.GetSprite().position.y - location.y
    }
}