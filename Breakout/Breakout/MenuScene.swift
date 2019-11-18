//
//  MenuScene.swift
//  Breakout
//
//  Created by Faiz Ikhwan on 14/11/2019.
//  Copyright © 2019 Faiz Ikhwan. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
        
    override func didMove(to view: SKView) {
        setupButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        guard let name = touchedNode.name else { return }
        if name == "Play Button" {
            guard let gameScene = GameScene(fileNamed: "GameScene") else { return }
            gameScene.scaleMode = .aspectFill
            scene?.view?.presentScene(gameScene, transition: .reveal(with: .down, duration: 1.0))
        }
    }
    
    func setupButton() {
        let playButton = SKSpriteNode(imageNamed: "Play Button")
        playButton.name = "Play Button"
        playButton.isUserInteractionEnabled = false
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playButton)
    }
}
