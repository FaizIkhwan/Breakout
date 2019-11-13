//
//  GameScene.swift
//  Breakout
//
//  Created by Faiz Ikhwan on 13/11/2019.
//  Copyright © 2019 Faiz Ikhwan. All rights reserved.
//

import AVFoundation
import GameplayKit
import SpriteKit

class GameScene: SKScene {
    
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var audioPlayer: AVAudioPlayer!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        scoreLabel = self.childNode(withName: "Score") as! SKLabelNode
        setupAudioPlayer()
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
        
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
//            paddle.run(SKAction.move)
//            paddle.run(SKAction.move(to: CGPoint(x: touchLocation.x, y: paddle.position.y), duration: 0.1))
            paddle.position.x = touchLocation.x
        }
    }
    
    func setupAudioPlayer() {
        let urlPath = Bundle.main.url(forResource: "brick", withExtension: "wav")
        guard let url = urlPath else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
        } catch {
            print("error")
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        
        if (bodyAName == "Ball" && bodyBName == "Brick") || bodyAName == "Brick" && bodyBName == "Ball" {
            if bodyAName == "Brick" {
                DispatchQueue.background(delay: 0.0, background: {
                    self.audioPlayer.play()
                })
                contact.bodyA.node?.removeFromParent()
                score += 1
            } else if bodyBName == "Brick" {
                DispatchQueue.background(delay: 0.0, background: {
                    self.audioPlayer.play()
                })
                contact.bodyB.node?.removeFromParent()
                score += 1
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Winning logic
        if (score == 9) {
            scoreLabel.text = "You Won!"
            self.view?.isPaused = true
        }
        
        // Losing logic
        if (ball.position.y < paddle.position.y) {
            scoreLabel.text = "You Lost!"
            self.view?.isPaused = true
        }
    }
}
