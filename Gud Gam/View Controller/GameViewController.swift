//
//  GameViewController.swift
//  Gud Gam
//
//  Created by Levi Nelson on 9/29/19.
//  Copyright © 2019 Get Swifty. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
  
             // Present the scene
             if let view = self.view as! SKView? {
            // Get the SKScene from the loaded GKScene
            let sceneNode = GameScene(size: view.bounds.size)
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                    
                
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = false
                    
                    view.showsFPS = false
                    view.showsNodeCount = false
                
            }
        }
    

}
