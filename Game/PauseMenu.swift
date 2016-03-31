//
//  PauseMenu.swift
//  Game
//
//  Created by Владислав Афанасьев on 30/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class PauseMenu
{
    var background: SKSpriteNode!
    var mainMenuButton: SKButton!
    var restartButton: SKButton!
    var soundButton: SKButton!
    var resumeButton: SKButton!
    
    var width: CGFloat!
    var height: CGFloat!
    
    var bwidth: CGFloat!
    var bheight: CGFloat!
    var bspace: CGFloat!
    
    var position: CGPoint!
    
    init(size: CGSize, x: CGFloat, y: CGFloat, sound: Bool)
    {
        position = CGPoint(x: x, y: y)
        self.width = size.width
        self.height = size.height
        CreateBackground()
        CreateResumeButton()
        CreateRestartButton()
        CreateSoundButton(sound)
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
                                 x: 0, y: background.size.width/2 - bheight*3/2 - bspace * 2,
                                 imageName: "Button", name: "Restart")
        restartButton.SetText("Restart")
        background.addChild(restartButton.GetSprite())
        
    }
    
    func CreateResumeButton()
    {
        resumeButton = SKButton(size: CGSize(width: 0.9, height: 0.2), contextWidth: background.size.width,
                                 x: 0, y: background.size.width/2 - bheight/2 - bspace,
                                 imageName: "Button", name: "Resume")
        resumeButton.SetText("Resume")
        background.addChild(resumeButton.GetSprite())
        
    }

    func CreateSoundButton(sound: Bool)
    {
        soundButton = SKButton(size: CGSize(width: 0.9, height: 0.2), contextWidth: background.size.width,
                                x: 0, y: -background.size.width/2 + bheight*3/2 + bspace * 2,
                                imageName: "Button", name: "Sound")
        if sound
        {
            soundButton.SetText("Sound: On")
        }
        else
        {
            soundButton.SetText("Sound: Off")
        }
        background.addChild(soundButton.GetSprite())
    }
    
    func SwitchSound(inout sound: Bool)
    {
        sound = !sound
        if sound
        {
            soundButton.SetText("Sound: On")
        }
        else
        {
            soundButton.SetText("Sound: Off")
        }
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
    
    func CloseMenu()
    {
        background.removeFromParent()
    }
}