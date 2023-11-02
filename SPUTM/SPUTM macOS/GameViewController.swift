//
//  GameViewController.swift
//  SPUTM macOS
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScummEngine()
        
        let scene = GameScene.newGameScene()
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    private func setupScummEngine() {
        
        guard let engine = try? Engine() else {
            fatalError("Engine not working")
        }
        
        engine.run()
    }
}

