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

private var circledx: CGFloat!
private var circledy: CGFloat!

private var score: CGFloat = 0
private var best: CGFloat = 0

private var diamonds: Int = 0
private var GameStarted = false
private var shipParametres: Array<Dictionary<String,String>>!
private var index: Int! = 0

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

struct BonusType
{
    static let shield: Int = 0
    static let shieldS = "BonusShield"
    
    static let fuel: Int = 1
    static let fuelS = "BonusFuel"
    
    static let health: Int = 2
    static let healthS = "BonusHealth"
    
    static let count: CGFloat = 3
}


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
        UI.buttonOk = SKButton(size: CGSize(width: size.width*0.3, height: (size.width*0.3)/2), x: size.width/2, y: size.height*0.2, imageName: "ButtonOK")
        UI.buttonOk.SetText("OK")
        self.addChild(UI.buttonOk.GetSprite())
        
        UI.arrowL = SKButton(size: CGSize(width: size.width/8, height: size.width/8), x: size.width/2 - size.width/5, y: size.height*0.35, imageName: "ArrowL")
        self.addChild(UI.arrowL.GetSprite())
        
        UI.arrowR = SKButton(size: CGSize(width: size.width/8, height: size.width/8), x: size.width/2 + size.width/5, y: size.height*0.35, imageName: "ArrowR")
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
        CreateShipManager()
        CreatePlayer(GetShipParameters()[index])
        CreateStartLocation()
        CreateTopBar()
        //Pause(true)
        setState(.Menu)
    }
    func MeteoriteStart()
    {
        GameStarted = true
        player!.StartUseFuel()
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
                RemoveCircle()
                UpdateCirclePosition(touch)
                CreateCircle()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchedNode = self.nodeAtPoint(touch.locationInNode(self))
            if GameStarted && currentState == .Unpaused //&& touchedNode.zPosition != ZPositions.UI
            {
                let location = touch.locationInNode(self)
                if UI.circle != nil
                {
                    UI.circle.runAction(SKAction.moveTo(location, duration: 0.05))
                    OnTouch(touch)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchedNode = self.nodeAtPoint((touches.first?.locationInNode(self))!)
        if GameStarted && currentState == .Unpaused
        {
            RemoveCircle()
        }
        if touchedNode.name == "pauseButton"
        {
            UI.pauseButton.Click(self)
        }
        else
            if currentState == .Menu{
                if touchedNode.name == UI.buttonOk.GetSprite().name
                {
                    player!.CreateFire()
                    setState(.Unpaused)
                    for x in self.children{
                        if x.name == UI.arrowL.GetSprite().name || x.name == UI.arrowR.GetSprite().name || x.name == UI.buttonOk.GetSprite().name
                        {
                            x.runAction(SKAction.sequence([
                        SKAction.fadeOutWithDuration(0.5),
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
    }
    
    func UpdateCirclePosition(touch: UITouch)
    {
        let location = touch.locationInNode(self)
        
        circledx = player.GetSprite().position.x - location.x
        circledy = player.GetSprite().position.y - location.y
    }
    
    func OnTouch(touch: UITouch)
    {
        let location = touch.locationInNode(self)
        let ti:Double = Double(sqrt((location.x + circledx - player!.GetSprite().position.x)*(location.x + circledx - player!.GetSprite().position.x) + (location.y + circledy - player!.GetSprite().position.y)*(location.y + circledy - player!.GetSprite().position.y))/size.width) * Double(player!.speed)

        if  !self.scene!.paused
        {
            let c: Double = player!.GetSprite().position.x > location.x + circledx ? 1 : -1
            let angle = c*Double(abs(location.x + circledx - player!.GetSprite().position.x)/size.width/2)
            
            var moveActionX = SKAction()
            var moveActionY = SKAction()
            var rotateAction = SKAction()
            
            if location.x + circledx < size.width-player!.GetSprite().size.width/2 &&
            location.x + circledx > player!.GetSprite().size.width/2
            {
                moveActionX = SKAction.moveToX(location.x + circledx, duration: ti)
                let rl = SKAction.rotateToAngle(CGFloat(angle), duration: ti*2/3, shortestUnitArc: true)
                let rr = SKAction.rotateToAngle(0, duration: ti*1/3, shortestUnitArc: true)
                rotateAction = SKAction.sequence([rl, rr])

            }
            
            if location.y + circledy < size.height-player!.GetSprite().size.height/2 &&
            location.y + circledy > player!.GetSprite().size.height/2
            {
                moveActionY = SKAction.moveToY(location.y + circledy, duration: ti)
                
            }
            player!.GetSprite().runAction(SKAction.group([moveActionX, moveActionY, rotateAction]))
            
        }
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
        if(bodyA.memory.node?.name == "diamond" && bodyB.memory.node?.name == "player")
        {
            if bodyA.memory.node?.parent != nil
            {
                bodyA.memory.node?.removeFromParent()
                GetDiamond()
                UI.diamondBar.UpdateDiamond(diamonds)
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
        if (bodyA.memory.node?.name == BonusType.fuelS && bodyB.memory.node?.name == "player")
        {
            player.FuelBonusOn()
            bodyA.memory.node?.removeFromParent()

        }
        ////////////////////////
        if (bodyA.memory.node?.name == BonusType.healthS && bodyB.memory.node?.name == "player")
        {
            player.Heal()
            bodyA.memory.node?.removeFromParent()
        }
        /////////////////////
        if (bodyA.memory.node?.name == "fuel" && bodyB.memory.node?.name == "player")
        {
            player.UseFuel(50)
            bodyA.memory.node?.removeFromParent()
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
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ExitFromBackground), name: "pause", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ExitFromBackground), name: UIApplicationDidBecomeActiveNotification, object: nil)
        score = 0
        diamonds = 0
        meteoriteSpeed = 3
        dSpeed = 0.1
        //currentState = .Menu
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
                SKAction.waitForDuration(NSTimeInterval(Rand.random(min: backgroundSpeed*2/3, max: backgroundSpeed*4/3))),
                SKAction.runBlock(CreatePlanet)
                ])
            ))
        
    }
    
    func CreateMeteoriteOrBonus()
    {
        if time % 80 == 0 && time != 0
        {
            CreateDiamond()
            time = 0
        }
        else
        if time % 50 == 0 && time != 0
        {
            CreateFuel()
        }
        else
        if time % 15 == 0
        {
            CreateBonus()
        }
        else
        {
            AddMeteorite()
        }
        time += 1
    }
    
    func CreateDiamond()
    {
        let diamond = Diamond(name: "DiamondIcon",
                              size: size.width/10,
                              position: CGPoint(x: Rand.random(min:0, max:size.width),y: size.height+size.width/20),
                              duration: NSTimeInterval(meteoriteSpeed), sceneSize: size)
        addChild(diamond.GetSprite())
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
    
    func CreateBonus()
    {
        let bonus = Bonus(type: Int(Rand.random(min: 0, max: BonusType.count)), sceneSize: size, duration: NSTimeInterval(meteoriteSpeed))
        addChild(bonus.GetSprite())
    }
    
    func CreateFuel()
    {
        let fuel = Fuel(size: size)
        addChild(fuel.GetSprite())
    }
    
    
    func IncreaseDifficulty()
    {
        if meteoriteSpeed - dSpeed >= 1
        {
            meteoriteSpeed = meteoriteSpeed - dSpeed
        }
    }
    
    func GetDiamond()
    {
        diamonds += 1
    }

    func CreateCircle()
    {
        UI.circle = SKSpriteNode(imageNamed: "Circle")
        UI.circle.name = "circle"
        UI.circle.size = CGSize(width: 60, height: 60)
        UI.circle.position.x = player!.GetSprite().position.x - circledx
        UI.circle.position.y = player!.GetSprite().position.y - circledy
        UI.circle.zPosition = ZPositions.UI
        self.addChild(UI.circle)
    }
    
    func RemoveCircle()
    {
        if UI.circle != nil
        {
            UI.circle.removeFromParent()
        }
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
        case .Paused,.Menu:
            Pause(true)
            break
        case .Unpaused:
            Pause(false)
            break
        default:
            Pause(true)
        }
        UI.pauseButton.SetTexture()

    }
   
    override func update(currentTime: CFTimeInterval) {
        if player != nil && (player.NoFuel() || player.IsDead())
        {
            NewGame()
        }
    }
}
