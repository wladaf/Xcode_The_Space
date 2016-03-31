//
//  GameScene.swift
//  Game
//
//  Created by Владислав Афанасьев on 26/02/16.
//  Copyright (c) 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

var player: Ship!

private var time: Int = 0

private var sound = true

private var score: CGFloat = 0
private var best: CGFloat = 0

private var GameStarted = false
private var shipParametres: Array<Dictionary<String,String>>!
private var index: Int! = 0

private var firstGame = true

public var meteoriteSpeed:CGFloat = 3
public var dSpeed:CGFloat = 0.1
public var backgroundSpeed: CGFloat! = 25

struct PhysicsCategory {
    static let None      : UInt32 = 0b0
    static let All       : UInt32 = UInt32.max
    static let Player   : UInt32 = 0b1
    static let Meteorite: UInt32 = 0b10
    static let Bonus: UInt32 = 0b100
    static let Fuel: UInt32 = 0b1000
    static let Shield: UInt32 = 0b10000
}

struct ZPositions{
    static let Player: CGFloat = 0
    static let Background: CGFloat = -10
    static let Meteorite: CGFloat = 1
    static let Planet: CGFloat = -9
    static let UI: CGFloat = 10
    static let UICircle: CGFloat = 8
    static let Bonus: CGFloat = 2
    static let Clouds: CGFloat = 9
}

enum State{
    case Paused
    case Unpaused
    case Menu
    case Default
}
var currentState: State = .Default

class GameScene: SKScene, SKPhysicsContactDelegate  {
    override func didMoveToView(view: SKView) {
        NewGame()
    }
    
    func CreateStartLocation()
    {
        self.backgroundColor = UIColor.init(colorLiteralRed: 60/255, green: 194/255, blue: 238/255, alpha: 1)
        
        let background = SKSpriteNode(imageNamed: "BG0")
        background.position = CGPoint(x: size.width/2, y: size.height/2-40)
        background.zPosition = ZPositions.Background
        background.setScale(size.height/background.size.height)
        let bgma = SKAction.moveToY(-background.size.height/2, duration: 3)
        let bgrm = SKAction.removeFromParent()
        background.runAction(SKAction.sequence([bgma,bgrm]))
        self.addChild(background)
        
        let clouds = SKSpriteNode(imageNamed: "Clouds")
        clouds.setScale(size.width*2/clouds.size.width)
        clouds.position = CGPoint(x: size.width/2, y: size.height+clouds.size.height)
        clouds.zPosition=ZPositions.Clouds
        let clma1 = SKAction.moveToY(size.height/2, duration: 3)
        let clma2 = SKAction.moveToY(-clouds.size.height/2, duration: 2)
        let clrm = SKAction.removeFromParent()
        clouds.runAction(SKAction.sequence([clma1, SKAction.runBlock(PrepareSpace) , clma2, SKAction.runBlock(MeteoriteStart), clrm]))
        self.addChild(clouds)
    }
    
    func CreateShipManager()
    {
        UI.buttonOk = SKButton(size: CGSize(width: 0.3, height: 0.15), contextWidth: size.width ,x: size.width/2, y: size.height*0.2, imageName: "Button", name: "ButtonOk")
        UI.buttonOk.SetText("OK")
        self.addChild(UI.buttonOk.GetSprite())
        
        UI.arrowL = SKButton(size: CGSize(width: 0.15, height:0.15),
                             contextWidth: size.width , x: size.width/2 - size.width/5, y: size.height*0.35, imageName: "ArrowL", name: "ArrowL", slicing: false)
        self.addChild(UI.arrowL.GetSprite())
        
        UI.arrowR = SKButton(size: CGSize(width: 0.15, height: 0.15), contextWidth: size.width, x: size.width/2 + size.width/5, y: size.height*0.35, imageName: "ArrowR", name: "ArrowR", slicing: false)
        self.addChild(UI.arrowR.GetSprite())
    }
    
    func PrepareSpace()
    {
        backgroundColor = SKColor.blackColor()
        CreateStars()
        BeginActions()
    }
    
    func NewGame()
    {
        self.removeAllChildren()
        self.removeAllActions()
        
        SceneSettings()
        CreatePlayer(GetShipParameters()[index])
        CreateTopBar()
        CreateShipManager()
        if firstGame
        {
            CreateStartLocation()
            firstGame = false
        }
        else
        {
            PrepareSpace()
            MeteoriteStart()
        }
        
        setState(.Default)
    }
    func MeteoriteStart()
    {
        GameStarted = true
        player!.StartUseFuel()
        CreateCircle()
        runAction(SKAction.repeatActionForever(
                        SKAction.sequence([
                        SKAction.runBlock(CreateMeteoriteOrBonus),
                        SKAction.waitForDuration(0.2)
                        ])
                    ))
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchedNode = self.nodeAtPoint(touch.locationInNode(self))
            if GameStarted && currentState == .Unpaused && touchedNode.zPosition != ZPositions.UI
            {
                UI.circle.UpdateDPosition(touch, context: self)
                UI.circle.SetPosition(CGPoint(x: player!.GetSprite().position.x - UI.circle.circledx, y: player!.GetSprite().position.y - UI.circle.circledy))
                UI.circle.SetHeddin(false)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if GameStarted && currentState == .Unpaused
            {
                let location = touch.locationInNode(self)
                if UI.circle != nil
                {
                    if !UI.circle.GetSprite().hidden
                    {
                        UI.circle.MoveTo(location)
                        OnTouch(touch)
                    }
                    else
                    {
                        UI.circle.UpdateDPosition(touch, context: self)
                        UI.circle.SetPosition(CGPoint(x: player!.GetSprite().position.x - UI.circle.circledx, y: player!.GetSprite().position.y - UI.circle.circledy))
                        UI.circle.SetHeddin(false)
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchedNode = self.nodeAtPoint((touches.first?.locationInNode(self))!)
        if GameStarted && currentState == .Unpaused
        {
            UI.circle.SetHeddin(true)
        }
        if touchedNode.name == "pauseButton"
        {
            UI.pauseButton.Click(self)
        }
        else
            if currentState == .Default{
                if touchedNode.name == UI.buttonOk.GetSprite().name
                {
                    player!.CreateFire()
                    setState(.Unpaused)
                    for x in self.children{
                        if x.name == UI.arrowL.GetSprite().name || x.name == UI.arrowR.GetSprite().name || x.name == UI.buttonOk.GetSprite().name
                        {
                            x.runAction(SKAction.sequence([
                        SKAction.fadeOutWithDuration(0.25),
                        SKAction.removeFromParent()]))
                        }
                    }
                }
                else
                    if touchedNode.name == UI.arrowL.GetSprite().name
                    {
                        index = StepLeft(index, n: GetJsonCount())
                        CreatePlayer(GetShipParameters()[index])
                    }
                    else
                        if touchedNode.name == UI.arrowR.GetSprite().name
                        {
                            index = StepRight(index, n: GetJsonCount())
                            CreatePlayer(GetShipParameters()[index])
                }
                
        }
        if currentState == .Menu
        {
            if touchedNode.name == "Restart"
            {
                NewGame()
            }
            if touchedNode.name == "MainMenu"
            {
                NSNotificationCenter.defaultCenter().postNotificationName("Exit", object: nil)
            }
        }
        if currentState == .Paused{
            if touchedNode.name == "MainMenu"
            {
                NSNotificationCenter.defaultCenter().postNotificationName("Exit", object: nil)
            }
            if touchedNode.name == "Restart"
            {
                NewGame()
            }
            if touchedNode.name == "Resume"
            {
                UI.pauseMenu.CloseMenu()
                setState(.Unpaused)
            }
            if touchedNode.name == "Sound"
            {
                UI.pauseMenu.SwitchSound(&sound)
            }

        }
    }
    
    func OnTouch(touch: UITouch)
    {
        let location = touch.locationInNode(self)
        //if  !self.scene!.paused
        //{
            let c: Double = player!.GetSprite().position.x > location.x + UI.circle.circledx ? 1 : -1
            let angle = c*Double(abs(location.x + UI.circle.circledx - player!.GetSprite().position.x)/size.width/2)
            
            let xloc = min(max(location.x + UI.circle.circledx, 0), size.width)
            let yloc = min(max(location.y + UI.circle.circledy, 0), size.height)
            
             let ti = Double(sqrt((xloc - player!.GetSprite().position.x) * (xloc - player!.GetSprite().position.x) + (yloc - player!.GetSprite().position.y) * ((yloc - player!.GetSprite().position.y)))/size.width) * Double(player!.speed)

            let moveActionX = SKAction.moveToX(xloc, duration: ti)
            let moveActionY = SKAction.moveToY(yloc, duration: ti)
            let rl = SKAction.rotateToAngle(CGFloat(angle), duration: ti*2/3, shortestUnitArc: true)
            let rr = SKAction.rotateToAngle(0, duration: ti*1/3, shortestUnitArc: true)
            let rotateAction = SKAction.sequence([rl, rr])
            
            player!.GetSprite().runAction(SKAction.group([moveActionX, moveActionY, rotateAction]))
        //}
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = UnsafeMutablePointer<SKPhysicsBody>.alloc(1)
        let bodyB = UnsafeMutablePointer<SKPhysicsBody>.alloc(1)
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask
        {
            bodyA.initialize(contact.bodyA)
            bodyB.initialize(contact.bodyB)
        }
        else
        {
            bodyA.initialize(contact.bodyB)
            bodyB.initialize(contact.bodyA)
        }
        
        if(bodyA.memory.node?.name == "meteorite" && bodyB.memory.node?.name == "player" && player?.shieldIsOn == false)
        {
            let w: CGFloat = (bodyA.memory.node?.frame.size.width)!
            if bodyA.memory.node?.parent != nil
            {
                bodyA.memory.node?.removeFromParent()
                player.Damage(w/size.width*700)
            }
        }
        ////////////////////////
        if (player?.shieldIsOn == true && bodyA.memory.node?.name == "shield" && bodyB.memory.node?.name == "meteorite")
        {
            player.ShieldOff()
            bodyB.memory.node?.removeFromParent()
        }
        ////////////////////////
        if (bodyA.memory.node?.name == BonusType.shieldS && bodyB.memory.node?.name == "player")
        {
            player.ShieldOn()
            bodyA.memory.node?.removeFromParent()
        }
        ////////////////////////
        if (bodyA.memory.node?.name == BonusType.infFuelS && bodyB.memory.node?.name == "player")
        {
            player.InfFuelBonusOn()
            bodyA.memory.node?.removeFromParent()

        }
        ////////////////////////
        if (bodyA.memory.node?.name == BonusType.healthS && bodyB.memory.node?.name == "player")
        {
            player.Heal()
            bodyA.memory.node?.removeFromParent()
        }
        /////////////////////
        if (bodyA.memory.node?.name == BonusType.fuelS && bodyB.memory.node?.name == "player")
        {
            player.FuelBonusOn()
            bodyA.memory.node?.removeFromParent()
        }
        /////////////////////
        if (bodyA.memory.node?.name == BonusType.diamondS && bodyB.memory.node?.name == "player")
        {
            if bodyA.memory.node?.parent != nil
            {      
                player.GetDiamondBonus()
                bodyA.memory.node?.removeFromParent()
                UI.diamondBar.UpdateDiamond(player.diamonds)
            }
        }
        
        bodyA.destroy()
        bodyA.dealloc(1)
        bodyB.destroy()
        bodyB.dealloc(1)
    }
    
    func AddMeteorite()
    {
        let r = Rand.random(min: size.width/20, max: size.width/7)
        let meteorite = Meteorite(name: "Moon", size: r,
            position: CGPoint(x: Rand.random(min:0, max:size.width),y: size.height+r/2),
        duration: NSTimeInterval(meteoriteSpeed), sceneSize: size)
        addChild(meteorite.GetSprite())
        
    }
    
    func CreateStars()
    {
        for _ in 0...20
        {
            let star = BackgroundStar(x: Rand.random(min:0, max:size.width), y: Rand.random(min:0, max:size.height), size: size)
            self.addChild(star.GetSprite())
        }
    }
    
    func AddStar()
    {
        let star = BackgroundStar(x: Rand.random(min:0, max:size.width), y: size.height, size: size)
        self.addChild(star.GetSprite())
    }
    
    func CreatePlayer(ship: Dictionary<String,String>)
    {
        if player != nil{
            player!.GetSprite().removeFromParent()
        }
        player = Ship(ship: ship, sceneWidth: size.width, position: CGPoint(x: size.width * 0.5, y: size.height * 0.35))
        self.addChild(player!.GetSprite())
       
    }
    
    func CreatePlanet()
    {
        let planet = Planet(planetType: Int(Rand.random(min: 0, max: 5)),
            size: size,
            position: CGPoint(x: Rand.random(min: 0, max: size.width), y: size.height+size.width))
        self.addChild(planet.planet)

    }
    
    func CreateTopBar()
    {
        UI.topBar = TopBar(image: "TopBar", size: size)
        self.addChild(UI.topBar.GetSprite())
    }
    
    
    func SceneSettings()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ExitFromBackground), name: UIApplicationDidBecomeActiveNotification, object: nil)
        score = 0
        meteoriteSpeed = 3
        dSpeed = 0.1
        GameStarted = false
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    func BeginActions()
    {
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(AddStar),
                SKAction.waitForDuration(NSTimeInterval(backgroundSpeed)/20)
                ])
            ))
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(ChangeScore),
                SKAction.waitForDuration(0.01)
                ])
            ))
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(IncreaseDifficulty),
                SKAction.waitForDuration(5)
                ])
            ))
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(5)),
                SKAction.runBlock(CreatePlanet)
                ])
            ))
         //SKAction.waitForDuration(NSTimeInterval(Rand.random(min: backgroundSpeed*2/3, max: backgroundSpeed*4/3)))
        
    }
    
    func CreateMeteoriteOrBonus()
    {
        if time % 80 == 0 && time != 0
        {
            CreateBonus(BonusType.diamond)
            time = 0
        }
        else
        if time % 50 == 0 && time != 0
        {
            CreateBonus(BonusType.fuel)
        }
        else
        if time % 15 == 0
        {
            CreateBonus(Int(Rand.random(min: 0, max: BonusType.rCount)))
        }
        else
        {
            AddMeteorite()
        }
        time += 1
    }
    
    func ChangeScore()
    {
        score = score + 7/meteoriteSpeed
        if best < score
        {
            best = score
        }
        UI.scoreLabel.GetLabel().text = "\(Int(score))km"
    }
    
    func CreateBonus(type: Int)
    {
        let bonus = Bonus(type: type, sceneSize: size, duration: NSTimeInterval(meteoriteSpeed))
        addChild(bonus.GetSprite())
    }
    
    
    func IncreaseDifficulty()
    {
        if meteoriteSpeed - dSpeed >= 1
        {
            meteoriteSpeed = meteoriteSpeed - dSpeed
        }
    }
    
    func CreateCircle()
    {
        UI.circle = Circle()
        self.addChild(UI.circle.GetSprite())
    }
    
    func Pause(value: Bool)
    {
        self.paused = value
    }
    
    func ExitFromBackground()
    {
        if currentState == .Unpaused
        {
            setState(.Paused)
        }
        else
        {
            setState(currentState)
        }
    }
    
    func setState(state: State)
    {
        currentState = state
        switch currentState {
        case .Menu:
            Pause(true)
            break
        case .Paused:
            Pause(true)
            if  UI.pauseMenu == nil || (UI.pauseMenu != nil && UI.pauseMenu.GetSprite().parent == nil)
            {
                CreatePauseMenu()
            }
            break
        case .Unpaused:
            Pause(false)
            if UI.pauseMenu != nil
            {
                UI.pauseMenu.CloseMenu()
            }
            break
        default:
            Pause(true)
        }
        UI.pauseButton.SetTexture()

    }
    
    func CreateMenu()
    {
        UI.menu = Menu(size: size, best: best, score: score, x: size.width/2, y: size.height/2)
        self.addChild(UI.menu.GetSprite())
    }
    
    func CreatePauseMenu()
    {
        UI.pauseMenu = PauseMenu(size: size, x: size.width/2, y: size.height/2, sound: sound)
        self.addChild(UI.pauseMenu.GetSprite())
    }
   
    override func update(currentTime: CFTimeInterval) {
        if player != nil && (player.NoFuel() || player.IsDead())
        {
            //NewGame()
            setState(.Menu)
            CreateMenu()
        }
    }
}
