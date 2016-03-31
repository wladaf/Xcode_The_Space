//
//  MenuViewController.swift
//  Game
//
//  Created by Владислав Афанасьев on 20/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet var btnStart: Button!
    @IBOutlet var btnShip: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnStart.SetText("Start")
        btnStart.SetAction(StartGame)
        
        btnShip.SetText("Ship")
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
    
    func StartGame()
    {
        let transition = CATransition()
        transition.delegate = self
        transition.duration = 1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromBottom;
        self.view.layer.addAnimation(transition, forKey: kCATransition)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Game") as! GameViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}