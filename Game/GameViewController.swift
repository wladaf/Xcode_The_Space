//
//  GameViewController.swift
//  Game
//
//  Created by Владислав Афанасьев on 26/02/16.
//  Copyright (c) 2016 Владислав Афанасьев. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsDrawCount = true
//            skView.showsQuadCount = true
            skView.multipleTouchEnabled = false
            skView.ignoresSiblingOrder = false
            //skView.showsPhysics = true
            scene.scaleMode = .ResizeFill
            
            scene.userData = NSMutableDictionary()
            //scene.userData!.setValue("Spaceship2", forKey: "ship")
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
        
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
