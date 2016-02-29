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

var angle: Double = 0
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



class GameScene: SKScene, SKPhysicsContactDelegate  {
    override func didMoveToView(view: SKView) {
        NewGame()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let ti:Double = Double(abs(location.x-player!.GetSprite().position.x)/size.width)
            
            if player!.GetSprite().position.x != location.x
            {
                if player!.GetSprite().position.x > location.x
                {
                    angle = Double(abs(location.x-player!.GetSprite().position.x)/size.width)
                }
                else
                {
                    angle = -Double(abs(location.x-player!.GetSprite().position.x)/size.width)
                }
                let moveAction = SKAction.moveToX(location.x, duration: ti)
                let rl = SKAction.rotateToAngle(CGFloat(angle), duration: ti*3/4, shortestUnitArc: true)
                let rr = SKAction.rotateToAngle(0, duration: ti*1/4, shortestUnitArc: true)
                let rotateAction = SKAction.sequence([rl, rr])

                player!.GetSprite().runAction(moveAction)
                player!.GetSprite().runAction(rotateAction)
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let ti:Double = Double(abs(location.x-player!.GetSprite().position.x)/size.width)
            
            if player!.GetSprite().position.x != location.x
            {
                if player!.GetSprite().position.x > location.x
                {
                    angle = Double(abs(location.x-player!.GetSprite().position.x)/size.width)
                }
                else
                {
                    angle = -Double(abs(location.x-player!.GetSprite().position.x)/size.width)
                }
                let moveAction = SKAction.moveToX(location.x, duration: ti)
                let rl = SKAction.rotateToAngle(CGFloat(angle), duration: ti*3/4, shortestUnitArc: true)
                let rr = SKAction.rotateToAngle(0, duration: ti*1/4, shortestUnitArc: true)
                let rotateAction = SKAction.sequence([rl, rr])
                
                player!.GetSprite().runAction(moveAction)
                player!.GetSprite().runAction(rotateAction)
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        /*var player: SKPhysicsBody
        var meteorite: SKPhysicsBody
        if contact.bodyA.categoryBitMask == PhysicsCategory.Player
        {
            player = contact.bodyA
            meteorite = contact.bodyB
        } else {
            player = contact.bodyB
            meteorite = contact.bodyA
        }

        MeteorCollide(player.node as! SKSpriteNode, meteorite: meteorite.node as! SKSpriteNode)*/
        //contact.bodyA.node?.removeFromParent()
        //contact.bodyB.node?.removeFromParent()
        /*
        
        let scene = GameScene(fileNamed:"GameScene")
        scene!.scaleMode = .ResizeFill
        let newGame = SKTransition.flipHorizontalWithDuration(1)
        self.scene!.view?.presentScene(scene! , transition: newGame)*/
        NewGame()
    }
    
    func MeteorCollide(player:SKSpriteNode, meteorite:SKSpriteNode) {
        player.removeFromParent()
        meteorite.removeFromParent()
    }
    
    func NewGame()
    {
        self.removeAllChildren()
        self.removeAllActions()
        SetDefaults()
        BeginActions()
        CreateEarth()
        CreatePlayer()
        CreateAsteroidField()
        CreateScoreLabel()
    }
    
    func AddMeteorite()
    {
        let Meteorite = SKSpriteNode(imageNamed: "Meteorite")
        let r = random(min: 15, max: 45)
        Meteorite.size.width = r
        Meteorite.size.height = r
        Meteorite.position = CGPoint(x: random(min:0, max:size.width),y: size.height+Meteorite.frame.height/2)
        
        Meteorite.physicsBody = SKPhysicsBody(circleOfRadius: r/2)
        Meteorite.physicsBody?.dynamic = false
        Meteorite.physicsBody?.categoryBitMask = PhysicsCategory.Meteorite
        Meteorite.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        Meteorite.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let ra = SKAction.rotateByAngle(1, duration: NSTimeInterval(random(min:0.5,max: 2.5)))
        let ma = SKAction.moveToY(-Meteorite.frame.height/2, duration: NSTimeInterval(random(min:meteoriteMinSpeed*meteoriteMinSpeed/(meteoriteMinSpeed + dSpeed), max: meteoriteMaxSpeed*meteoriteMaxSpeed/(meteoriteMaxSpeed + dSpeed))))
        let da = SKAction.removeFromParent()
        Meteorite.runAction(SKAction.repeatActionForever(ra))
        Meteorite.runAction(SKAction.sequence([ma,da]))
        self.addChild(Meteorite)
    }
    
    func AddStars()
    {
        let Star = SKShapeNode(circleOfRadius:random(min:0.5, max: 1))
        Star.position = CGPointMake(random(min:0, max:size.width), size.height+Star.frame.height/2)
        Star.strokeColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        Star.fillColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        let ma = SKAction.moveToY(-Star.frame.height/2, duration: NSTimeInterval(backgroundSpeed))
        let da = SKAction.removeFromParent()
        Star.runAction(SKAction.sequence([ma,da]))
        self.addChild(Star)
    }
    
    func CreatePlayer()
    {
        player = Ship(Name: "Spaceship", Scale: Psize, Position: CGPoint(x: size.width * 0.5, y: size.height * 0.2))
        self.addChild(player!.GetSprite())
        
        
    }
    
    func CreateEarth()
    {
        let earth = SKSpriteNode(imageNamed: "Earth")
        let ma = SKAction.moveToY(-earth.size.height/2, duration: backgroundSpeed)
        let de = SKAction.removeFromParent()
        earth.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        earth.xScale = 0.35
        earth.yScale = 0.35
        self.addChild(earth)
        earth.runAction(SKAction.sequence([ma,de]))
    }
    
    func CreateScoreLabel(){
        lblScore.text = "Score: 0"
        lblScore.fontColor = SKColor.whiteColor()
        lblScore.fontSize = 20
        lblScore.position = CGPoint(x: size.width/2, y: size.height - lblScore.frame.height)
        self.addChild(lblScore)
    }
    
    func CreateAsteroid()
    {
        let Asteroid = SKEmitterNode(fileNamed: "Fire.sks")
        Asteroid!.position = CGPoint(x:size.width + 30, y: random(min: 0, max: size.height))
        Asteroid!.fieldBitMask = PhysicsCategory.Field
        Asteroid!.xScale = 0.1
        Asteroid!.yScale = 0.1
        
        let ma = SKAction.moveTo(CGPoint(x: -100,y: random(min: 0, max: size.height)), duration: backgroundSpeed/10)
        let de = SKAction.removeFromParent()
        self.addChild(Asteroid!)
        Asteroid!.runAction(SKAction.sequence([ma,de]))
    }
    
    func CreateAsteroidField()
    {
        let asteroidField = SKFieldNode.linearGravityFieldWithVector(float3(10,-10,0))
        asteroidField.categoryBitMask = PhysicsCategory.Field
        self.addChild(asteroidField)
    }
    
    func SetDefaults()
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
                SKAction.runBlock(AddStars),
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
                SKAction.runBlock(CreateAsteroid),
                SKAction.waitForDuration(5)
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
