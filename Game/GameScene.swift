//
//  GameScene.swift
//  Game
//
//  Created by Владислав Афанасьев on 26/02/16.
//  Copyright (c) 2016 Владислав Афанасьев. All rights reserved.
//

import SpriteKit

var player: Ship!
let lblScore = SKLabelNode(fontNamed: "Arial")
let planetGenerator = PlanetGenerator()

var angle: Double = 0
var Score: CGFloat = 0
var record: CGFloat = 0

var meteoriteMaxSpeed:CGFloat = 3
var meteoriteMinSpeed:CGFloat = 2.5
var dSpeed:CGFloat = 0.1

var backgroundSpeed: CGFloat!


struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Player   : UInt32 = 0b1
    static let Meteorite: UInt32 = 0b10
    static let Bonus: UInt32 = 0b100
}

struct ZPositions{
    static let Player: CGFloat = 0
    static let Background: CGFloat = -10
    static let Meteorite: CGFloat = 1
    static let SpaceBody: CGFloat = -9
    static let UI: CGFloat = 10
    static let Bonus: CGFloat = 2
}

struct BonusType{
    static let Shield: CGFloat = 0
}


class GameScene: SKScene, SKPhysicsContactDelegate  {
    override func didMoveToView(view: SKView) {
        NewGame()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            OnTouch(touch)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            OnTouch(touch)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if lblScore.containsPoint((touches.first?.locationInNode(self))!)
        {
            self.scene!.paused = !self.scene!.paused
            
        }
    }
    
    func OnTouch(touch: UITouch)
    {
        let location = touch.locationInNode(self)
        let ti:Double = Double(abs(location.x-player!.GetSprite().position.x)/size.width)
        
        if player!.GetSprite().position.x != location.x && !self.scene!.paused && !lblScore.containsPoint((touch.locationInNode(self)))
        {
            if player!.GetSprite().position.x > location.x
            {
                angle = Double(abs(location.x-player!.GetSprite().position.x)/size.width/2)
                
            }
            else
            {
                angle = -Double(abs(location.x-player!.GetSprite().position.x)/size.width/2)
            }
            let moveAction = SKAction.moveToX(location.x, duration: ti)
            let rl = SKAction.rotateToAngle(CGFloat(angle), duration: ti*2/3, shortestUnitArc: true)
            let rr = SKAction.rotateToAngle(0, duration: ti*1/3, shortestUnitArc: true)
            let rotateAction = SKAction.sequence([rl, rr])
            player!.GetSprite().runAction(SKAction.group([moveAction,rotateAction]))
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
            if (contact.bodyA.node?.name == "bonusShield")
            {
                contact.bodyA.node?.removeFromParent()
            }
            else
            {
                contact.bodyB.node?.removeFromParent()
            }
        }
    }
    
    
    func NewGame()
    {
        self.removeAllChildren()
        self.removeAllActions()
        SceneSettings()
        BeginActions()
        CreateStars()
        CreateStartPlanet()
        CreatePlayer()
        CreateScoreLabel()
    }
    
    func AddMeteorite()
    {
        let r = Rand.random(min: size.width/20, max: size.width/7)
        let meteorite = Meteorite(name: "Moon", size: r,
            position: CGPoint(x: Rand.random(min:0, max:size.width),y: size.height+r/2),
        duration: NSTimeInterval((meteoriteMaxSpeed+meteoriteMinSpeed)/2), sceneSize: size)
        addChild(meteorite.GetSprite())
        meteorite.AddShadow("MeteoriteShadow")
        
    }
    
    func CreateStars()
    {
        for _ in 0...20
        {
            let Star = SKShapeNode(circleOfRadius: Rand.random(min:0.5, max: 1))
            Star.position = CGPointMake(Rand.random(min:0, max:size.width), Rand.random(min:0, max:size.height))
            Star.zPosition = ZPositions.Background
            Star.strokeColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.8)
            Star.fillColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.8)
            let ma = SKAction.moveToY(-Star.frame.height/2, duration: NSTimeInterval(CGFloat(backgroundSpeed) * (Star.position.y/size.height)))
            let da = SKAction.removeFromParent()
            Star.runAction(SKAction.sequence([ma,da]))
            self.addChild(Star)
        }
    }
    
    func AddStar()
    {
        let Star = SKShapeNode(circleOfRadius: Rand.random(min:0.5, max: 1))
        Star.position = CGPointMake(Rand.random(min:0, max:size.width), size.height+Star.frame.height/2)
        Star.zPosition = ZPositions.Background
        Star.strokeColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        Star.fillColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        let ma = SKAction.moveToY(-Star.frame.height/2, duration: NSTimeInterval(backgroundSpeed))
        let da = SKAction.removeFromParent()
        Star.runAction(SKAction.sequence([ma,da]))
        self.addChild(Star)
    }
    
    func CreatePlayer()
    {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            player = Ship(name: "Spaceship", size: size.width/10, position: CGPoint(x: size.width * 0.5, y: size.height * 0.35))
        }
        else
        {
            player = Ship(name: "Spaceship", size: size.width/10, position: CGPoint(x: size.width * 0.5, y: size.height * 0.15))
        }
        self.addChild(player!.GetSprite())
    }
    
    func CreateStartPlanet()
    {
//        let sheet = SKTextureAtlas(named: "PlanetAtlas")
//        let texture = sheet.textureNamed("Earth")
//        let earth = SKSpriteNode(texture: texture)

        let earth = planetGenerator.GetPlanet(PlanetType.AlivePlanet)
        earth.setScale(size.width/earth.size.width)
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            earth.position = CGPoint(x: size.width * 0.5, y: 0)
        }
        else
        {
            earth.position = CGPoint(x: size.width * 0.5, y: -size.height*0.3)
        }
        self.addChild(earth)
        let ma = SKAction.moveToY(-earth.size.height/2+earth.position.y, duration: NSTimeInterval(earth.size.width/size.height/2*backgroundSpeed*2/3))
        let de = SKAction.removeFromParent()
        earth.runAction(SKAction.sequence([ma,de]))
    }
    
    
    func CreateMiddlePlanet()
    {
        let spaceBody = planetGenerator.GetPlanet(Int(Rand.random(min: 0, max: 5)))
        //let spaceBody = planetGenerator.GetPlanet(PlanetType.BlackHole)
        spaceBody.zPosition = ZPositions.SpaceBody
        let scale = size.width/spaceBody.size.width*(Rand.random(min: 0.1, max: 0.5))
        spaceBody.setScale(scale)
        spaceBody.position = CGPoint(x: Rand.random(min: 0, max: size.width), y: size.height+spaceBody.size.height)
        let ma = SKAction.moveToY(-spaceBody.size.height/2, duration: NSTimeInterval(backgroundSpeed*2/3))
        let de = SKAction.removeFromParent()
        self.addChild(spaceBody)
        spaceBody.runAction(SKAction.sequence([ma,de]))

    }
    
    func CreateScoreLabel(){
        lblScore.text = "Score: 0"
        lblScore.fontColor = SKColor.whiteColor()
        lblScore.fontSize = 20
        lblScore.position = CGPoint(x: size.width/2, y: size.height - lblScore.frame.height)
        lblScore.zPosition = ZPositions.UI
        lblScore.name = "lbl_score"
        self.addChild(lblScore)
    }
    
    func SceneSettings()
    {
        angle = 0
        Score = 0
        
        meteoriteMaxSpeed = 3
        meteoriteMinSpeed = 2.5
        dSpeed = 0.1
        
        backgroundSpeed = 50
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.blackColor()
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
                SKAction.runBlock(AddMeteorite),
                SKAction.waitForDuration(0.2)
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
                SKAction.runBlock(CreateMiddlePlanet)
                ])
            ))
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(Rand.random(min: 10, max: 30))),
                SKAction.runBlock(CreateBonus)
                ])
            ))
    }
    
    func ChangeScore()
    {
        Score = Score + 7/meteoriteMaxSpeed
        if record < Score
        {
            record = Score
        }
        lblScore.text = "\(Int(Score)) km  (\(Int(record)))"
    }
    
    func CreateBonus()
    {
        let bonus = Bonus(type: BonusType.Shield, sceneSize: size, duration: NSTimeInterval((meteoriteMaxSpeed+meteoriteMinSpeed)/2))
        addChild(bonus.GetSprite())
    }
    
    
    func IncreaseDifficulty()
    {
        if meteoriteMinSpeed - dSpeed >= 1
        {
            meteoriteMinSpeed = meteoriteMinSpeed - dSpeed
            meteoriteMaxSpeed = meteoriteMaxSpeed - dSpeed
        }
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}
