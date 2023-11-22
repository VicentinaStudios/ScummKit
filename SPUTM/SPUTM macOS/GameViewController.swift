//
//  GameViewController.swift
//  SPUTM macOS
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Cocoa
import SpriteKit
import GameplayKit
import ScummCore

class GameViewController: NSViewController {
    
    private let gameInfo: GameInfo? = ScummGameDetector.gameInfo

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGame()
        
        let scene = GameScene.newGameScene()
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    private func setupGame() {
        
        guard let gameInfo = gameInfo else {
            fatalError("No SCUMM game detected")
        }
        
        guard let engine = try? Engine(gameInfo: gameInfo) else {
           fatalError("Engine not working")
       }
        
        engine.run()
    }
}

