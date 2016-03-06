//
//  GameScene.swift
//  Game
//
//  Created by Владислав Афанасьев on 26/02/16.
//  Copyright (c) 2016 Владислав Афанасьев. All rights reserved.
//

import SpriteKit

var player: Ship?
let lblScore = SKLabelNode(fontNamed: "Arial")
let planetGenerator = PlanetGenerator()

var angle: Double = 0
var curAngle: Double = 0
var Score = 0
var Psize: CGFloat = 0.2
var record = 0

var meteoriteMaxSpeed:CGFloat = 3
var meteoriteMinSpeed:CGFloat = 2.5
var dSpeed:CGFloat = 0.1

var backgroundSpeed: NSTimeInterval = 20

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Player   : UInt32 = 0b1
    static let Meteorite: UInt32 = 0b10
    static let Asteroid: UInt32 = 0b100
    static let Field: UInt32 = 0b1000
}

struct ZPositions{
    static let Player: CGFloat = 0
    static let Background: CGFloat = -10
    static let Meteorite: CGFloat = 1
    static let SpaceBody: CGFloat = -9
    static let UI: CGFloat = 10
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
        NewGame()
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
        //CreateScoreLabel()
    }
    
    func AddMeteorite()
    {
        let Meteorite = SKSpriteNode(imageNamed: "Moon")
        let r = random(min: 15, max: 45)
        Meteorite.size  = CGSize(width: r,height: r)
        Meteorite.position = CGPoint(x: random(min:0, max:size.width),y: size.height+Meteorite.frame.height/2)
        Meteorite.zPosition = ZPositions.Meteorite
        
        Meteorite.physicsBody = SKPhysicsBody(circleOfRadius: r/2)
        Meteorite.physicsBody?.dynamic = false
        Meteorite.physicsBody?.categoryBitMask = PhysicsCategory.Meteorite
        Meteorite.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        Meteorite.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let rotationSpeed = random(min:0.5,max: 2.5)
        var ra = SKAction.rotateByAngle(1, duration: NSTimeInterval(rotationSpeed))
        let ma = SKAction.moveTo(CGPoint(x: Meteorite.position.x + random(min: -size.width/10, max: size.width/10), y:-Meteorite.frame.height/2), duration: NSTimeInterval((meteoriteMaxSpeed+meteoriteMinSpeed)/2))
        
        let da = SKAction.removeFromParent()
        Meteorite.runAction(SKAction.repeatActionForever(ra))
        Meteorite.runAction(SKAction.sequence([ma,da]))
        self.addChild(Meteorite)
        
        ra = SKAction.rotateByAngle(-1, duration: NSTimeInterval(rotationSpeed))
        let Shadow = SKSpriteNode(imageNamed: "MeteoriteShadow")
        Shadow.size = CGSize(width: r,height: r)
        Shadow.position = CGPoint(x: 0,y: 0)
        Shadow.zPosition = 1
        Meteorite.addChild(Shadow)
        Shadow.runAction(SKAction.repeatActionForever(ra))
    }
    
    func CreateStars()
    {
        for _ in 0...20
        {
            let Star = SKShapeNode(circleOfRadius:random(min:0.5, max: 1))
            Star.position = CGPointMake(random(min:0, max:size.width), random(min:0, max:size.height))
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
        let Star = SKShapeNode(circleOfRadius:random(min:0.5, max: 1))
        Star.position = CGPointMake(random(min:0, max:size.width), size.height+Star.frame.height/2)
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
        player = Ship(Name: "Spaceship", Scale: Psize, Position: CGPoint(x: size.width * 0.5, y: size.height * 0.35))
        self.addChild(player!.GetSprite())
    }
    
    func CreateStartPlanet()
    {
//        let sheet = SKTextureAtlas(named: "PlanetAtlas")
//        let texture = sheet.textureNamed("Earth")
//        let earth = SKSpriteNode(texture: texture)

        let earth = planetGenerator.GetPlanet(PlanetType.AlivePlanet)
        earth.setScale(size.width/earth.size.width)
        earth.position = CGPoint(x: size.width * 0.5, y: 0)
        self.addChild(earth)
        let ma = SKAction.moveToY(-earth.size.height/2, duration: NSTimeInterval(earth.size.width/size.height/2)*backgroundSpeed*2/3)
        let de = SKAction.removeFromParent()
        earth.runAction(SKAction.sequence([ma,de]))
    }
    
    func CreateMiddlePlanet()
    {
        //let spaceBody = planetGenerator.GetPlanet(Int(random(min: 0, max: 4)))
        let spaceBody = planetGenerator.GetPlanet(PlanetType.AlivePlanet)
        spaceBody.zPosition = ZPositions.SpaceBody
        let scale = size.width/spaceBody.size.width*(random(min: 0.1, max: 0.6))
        spaceBody.setScale(scale)
        spaceBody.position = CGPoint(x: random(min: 0, max: size.width), y: size.height+spaceBody.size.height)
        let ma = SKAction.moveToY(-spaceBody.size.height/2, duration: backgroundSpeed*2/3)
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
        Psize = 0.2
        
        meteoriteMaxSpeed = 3
        meteoriteMinSpeed = 2.5
        dSpeed = 0.1
        
        backgroundSpeed = 20
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.blackColor()
    }
    
    func BeginActions()
    {
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(AddStar),
                SKAction.waitForDuration(1)
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
                SKAction.waitForDuration(0.1)
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
                SKAction.waitForDuration(NSTimeInterval(random(min: 5, max: 30))),
                SKAction.runBlock(CreateMiddlePlanet)
                ])
            ))
    }
    
    func ChangeScore()
    {
        Score = Score + 1
        if record < Score
        {
            record = Score
        }
        lblScore.text = "Score: \(Score) (\(record))"
    }
    
    func IncreaseDifficulty()
    {
        if meteoriteMinSpeed - dSpeed >= 1
        {
            meteoriteMinSpeed = meteoriteMinSpeed - dSpeed
            meteoriteMaxSpeed = meteoriteMaxSpeed - dSpeed
        }
    }

    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}
