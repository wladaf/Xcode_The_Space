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

private var angle: Double = 0
private var score: CGFloat = 0
private var record: CGFloat = 0
private var GameStarted = false
private var shipParametres: Array<Dictionary<String,String>>!

private var index: Int! = 0

public var meteoriteMaxSpeed:CGFloat = 3
public var meteoriteMinSpeed:CGFloat = 2.5
public var dSpeed:CGFloat = 0.1
public var backgroundSpeed: CGFloat! = 25

var circle = SKSpriteNode(imageNamed: "Circle")


struct UI {
    static var buttonOk: SKSpriteNode!
    static var arrowL: SKSpriteNode!
    static var arrowR: SKSpriteNode!
    static var bonusBar: BonusBar!
    static var fuelBar: FuelBar!
    static var lblScore: SKLabelNode!
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Player   : UInt32 = 0b1
    static let Meteorite: UInt32 = 0b10
    static let Bonus: UInt32 = 0b100
    static let Fuel: UInt32 = 0b1000
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

struct BonusType{
    static let Shield: CGFloat = 0
}


class GameScene: SKScene, SKPhysicsContactDelegate  {
    override func didMoveToView(view: SKView) {
        NewGame()
    }
    
    func CreateStartLocation()
    {
        self.backgroundColor = UIColor.init(colorLiteralRed: 60/255, green: 194/255, blue: 238/255, alpha: 1)
        
        let background = SKSpriteNode(imageNamed: "BG0")
        background.position = CGPoint(x: size.width/2, y: size.height/2-30)
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
    
    func ShipManager()
    {
        let ships: Array<SKSpriteNode>!
        
        UI.buttonOk = SKSpriteNode(imageNamed: "ButtonOK")
        UI.buttonOk.name = "ButtonStart"
        UI.buttonOk.position = CGPoint(x: size.width/2, y: size.height*0.2)
        UI.buttonOk.setScale(size.width/UI.buttonOk.size.width*0.3)
        UI.buttonOk.zPosition = ZPositions.UI
        self.addChild(UI.buttonOk)
        
        UI.arrowL = SKSpriteNode(imageNamed: "ArrowL")
        UI.arrowL.name = "ArrowL"
        UI.arrowL.position = CGPoint(x: size.width/2 - size.width/5, y: size.height*0.35)
        UI.arrowL.setScale(size.width/UI.arrowL.size.width*0.1)
        UI.arrowL.zPosition = ZPositions.UI
        self.addChild(UI.arrowL)
        
        UI.arrowR = SKSpriteNode(imageNamed: "ArrowR")
        UI.arrowR.name = "ArrowR"
        UI.arrowR.position = CGPoint(x: size.width/2 + size.width/5, y: size.height*0.35)
        UI.arrowR.setScale(size.width/UI.arrowR.size.width*0.1)
        UI.arrowR.zPosition = ZPositions.UI
        self.addChild(UI.arrowR)
        
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
        ShipManager()
        CreatePlayer(GetShipParameters()[index])
        CreateStartLocation()
        CreateScoreLabel()
        CreateBonusBar()
        CreateFuelBar()
        for x in self.children{
            x.paused=true
        }
        
        
    }
    
    func MeteoriteStart()
    {
        GameStarted = true
        CreateCircle()
        player!.StartUseFuel()
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
            SKAction.runBlock(AddMeteorite),
            SKAction.waitForDuration(0.2)
            ])
        ))
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if GameStarted
            {
                OnTouch(touch)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if GameStarted
            {
                OnTouch(touch)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchedNode = self.nodeAtPoint((touches.first?.locationInNode(self))!)
        if UI.lblScore.containsPoint((touches.first?.locationInNode(self))!)
        {
            self.scene!.paused = !self.scene!.paused
            
        }
        else
        if touchedNode.name == "ButtonStart"
        {
            for x in self.children{
                x.paused=false
                if x.name == "ArrowL" || x.name == "ArrowR" || x.name == "ButtonStart"
                {
                    x.removeFromParent()
                }
            }
        }
        else
        if touchedNode.name == "ArrowL"
        {
            index = StepLeft(index, n: GetJsonCount())
            CreatePlayer(GetShipParameters()[index])
        }
        else
        if touchedNode.name == "ArrowR"
        {
            index = StepRight(index, n: GetJsonCount())
            CreatePlayer(GetShipParameters()[index])
        }
    }
    
    func OnTouch(touch: UITouch)
    {
        let location = touch.locationInNode(self)
        let ti:Double = Double(sqrt((location.x-player!.GetSprite().position.x)*(location.x-player!.GetSprite().position.x) + (location.y + 100 - player!.GetSprite().position.y)*(location.y + 100-player!.GetSprite().position.y))/size.width)
        
        if  !self.scene!.paused && !UI.lblScore.containsPoint((touch.locationInNode(self)))
        {
            circle.runAction(SKAction.moveTo(location, duration: 0.05))
            if player!.GetSprite().position.x > location.x
            {
                angle = Double(abs(location.x-player!.GetSprite().position.x)/size.width/2)
                
            }
            else
            {
                angle = -Double(abs(location.x-player!.GetSprite().position.x)/size.width/2)
            }
            let moveActionX = SKAction.moveToX(location.x, duration: ti)
            var moveActionY: SKAction!
            if location.y+100 < size.height-player!.GetSprite().size.height/2
            {
                moveActionY = SKAction.moveToY(location.y+100, duration: ti)
                
            }
            else
            {
                moveActionY = SKAction.moveToY(size.height-player!.GetSprite().size.height/2
, duration: ti)
            }
//            let rl = SKAction.rotateToAngle(CGFloat(angle), duration: ti*2/3, shortestUnitArc: true)
//            let rr = SKAction.rotateToAngle(0, duration: ti*1/3, shortestUnitArc: true)
//            let rotateAction = SKAction.sequence([rl, rr])
//            player!.GetSprite().runAction(SKAction.group([moveActionX, moveActionY, rotateAction]))
            player!.GetSprite().runAction(SKAction.group([moveActionX, moveActionY]))
            
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if((contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "meteorite" ||
        contact.bodyB.node?.name == "player" && contact.bodyA.node?.name == "meteorite") && player?.shieldIsOn == false)
        {
            NewGame()
        }
        
        ////////////////////////
        if (contact.bodyA.node?.name == "shield" && contact.bodyB.node?.name == "meteorite")
        {
            player.ShieldOff()
            UI.bonusBar.SetOff()
            contact.bodyB.node?.removeFromParent()
        }
        if (contact.bodyB.node?.name == "shield" && contact.bodyA.node?.name == "meteorite")
        {
            player.ShieldOff()
            contact.bodyA.node?.removeFromParent()
        }
        
        ////////////////////////
        if (contact.bodyA.node?.name == "bonusShield" && contact.bodyB.node?.name == "player" ||
            contact.bodyB.node?.name == "bonusShield" && contact.bodyA.node?.name == "player")
        {
            player.ShieldOn()
            UI.bonusBar.SetOn("BonusShield", time: player!.GetBonusMultiplier()*8+2)
            if (contact.bodyA.node?.name == "bonusShield")
            {
                contact.bodyA.node?.removeFromParent()
            }
            else
            {
                contact.bodyB.node?.removeFromParent()
            }
        }
        /////////////////////
        if (contact.bodyA.node?.name == "fuel" && contact.bodyB.node?.name == "player" ||
            contact.bodyB.node?.name == "fuel" && contact.bodyA.node?.name == "player")
        {
            player.UseFuel(50)
            if (contact.bodyA.node?.name == "fuel")
            {
                contact.bodyA.node?.removeFromParent()
            }
            else
            {
                contact.bodyB.node?.removeFromParent()
            }
        }

    }
    
    func AddMeteorite()
    {
        let r = Rand.random(min: size.width/20, max: size.width/7)
        let meteorite = Meteorite(name: "Moon", size: r,
            position: CGPoint(x: Rand.random(min:0, max:size.width),y: size.height+r/2),
        duration: NSTimeInterval((meteoriteMaxSpeed+meteoriteMinSpeed)/2), sceneSize: size)
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
        //let name:String = String(self.userData!.valueForKey("ship")!)
        if player != nil{
            player!.GetSprite().removeFromParent()
        }
        let name = ship["name"]!
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            player = Ship(name: name, size: size.width/10, position: CGPoint(x: size.width * 0.5, y: size.height * 0.35))
        }
        else
        {
            player = Ship(name: name, size: size.width/10, position: CGPoint(x: size.width * 0.5, y: size.height * 0.15))
        }
        self.addChild(player!.GetSprite())
       
    }
    
    func CreatePlanet()
    {
        let planet = Planet(planetType: Int(Rand.random(min: 0, max: 5)),
            size: size,
            position: CGPoint(x: Rand.random(min: 0, max: size.width), y: size.height+size.width))
        self.addChild(planet.planet)

    }
    
    func CreateFuelBar()
    {
        UI.fuelBar = FuelBar(width: size.width/10, height: size.width/10*4/3,
            x: size.width-size.width/10*0.6, y:  size.height-size.width/10*4/3*0.6,
            backTextureName: "FuelBarBack", frontTextureName: "FuelBarFront", colorTexture: SKTexture(imageNamed: "PGRedToGreenColor"))
        self.addChild(UI.fuelBar.GetSprite())
    }
    
    func CreateBonusBar()
    {
        UI.bonusBar = BonusBar(image: "BonusShield", size: CGSize(width: size.width/8, height: size.width/8), position: CGPoint(x: 0, y: size.height))
        self.addChild(UI.bonusBar.GetSprite())
    }
    
    func CreateScoreLabel(){
        UI.lblScore = SKLabelNode(fontNamed: "Arial")
        UI.lblScore.text = "Score: 0 (\(Int(record)))"
        UI.lblScore.fontColor = SKColor.whiteColor()
        UI.lblScore.fontSize = 20
        UI.lblScore.position = CGPoint(x: size.width/2, y: size.height - UI.lblScore.frame.height)
        UI.lblScore.zPosition = ZPositions.UI
        UI.lblScore.name = "lbl_score"
        self.addChild(UI.lblScore)
    }
    
    func SceneSettings()
    {
        angle = 0
        score = 0
        
        meteoriteMaxSpeed = 3
        meteoriteMinSpeed = 2.5
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
                SKAction.waitForDuration(NSTimeInterval(Rand.random(min: backgroundSpeed*2/3, max: backgroundSpeed*4/3))),
                SKAction.runBlock(CreatePlanet)
                ])
            ))
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(Rand.random(min: 10, max: 30))),
                SKAction.runBlock(CreateBonus)
                ])
            ))
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(Rand.random(min: 10, max: 15))),
                SKAction.runBlock(CreateFuel)
                ])
            ))
        
    }
    
    func ChangeScore()
    {
        score = score + 7/meteoriteMaxSpeed
        if record < score
        {
            record = score
        }
        UI.lblScore.text = "\(Int(score)) km  (\(Int(record)))"
    }
    
    func CreateBonus()
    {
        let bonus = Bonus(type: BonusType.Shield, sceneSize: size, duration: NSTimeInterval((meteoriteMaxSpeed+meteoriteMinSpeed)/2))
        addChild(bonus.GetSprite())
    }
    
    func CreateFuel()
    {
        let fuel = Fuel(size: size)
        addChild(fuel.GetSprite())
    }
    
    
    func IncreaseDifficulty()
    {
        if meteoriteMinSpeed - dSpeed >= 1
        {
            meteoriteMinSpeed = meteoriteMinSpeed - dSpeed
            meteoriteMaxSpeed = meteoriteMaxSpeed - dSpeed
        }
    }
    
    func CreateCircle()
    {
        circle.size = CGSize(width: size.width/5, height: size.width/5)
        circle.position.x = player!.GetSprite().position.x
        circle.zPosition = ZPositions.UI
        circle.position.y = player!.GetSprite().position.y-100
        circle.alpha = 0
        circle.runAction(SKAction.fadeAlphaTo(0.5, duration: 2))
        self.addChild(circle)
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        if player != nil && player.NoFuel()
        {
            NewGame()
        }
    }
}
