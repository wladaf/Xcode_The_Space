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
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(Exit), name: "Exit", object: nil)
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsDrawCount = true
//            skView.showsQuadCount = true
            skView.multipleTouchEnabled = false
            skView.ignoresSiblingOrder = false
            //skView.showsPhysics = true
            scene.scaleMode = .ResizeFill
            
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
    
    func Exit()
    {
        let transition = CATransition()
        transition.delegate = self
        transition.duration = 3;
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom;
        //self.view.layer.addAnimation(transition, forKey: kCATransition)
        //let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        //let vc = storyboard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
        //self.dismissViewControllerAnimated(true, completion: nil)
        //self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "mySegue"{
            let vc = segue.destinationViewController as! MenuViewController
        }
    }
    
}
