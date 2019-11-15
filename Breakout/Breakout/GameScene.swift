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
    var initialTouchLocation = CGPoint()
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        scoreLabel = self.childNode(withName: "Score") as! SKLabelNode
        setupAudioPlayer()
        setupPaddle()
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        for touch in touches {
            initialTouchLocation = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved")
        for touch in touches {
            let touchLocation = touch.location(in: self)
            paddle.position.x = (touchLocation.x - initialTouchLocation.x)
//            paddle.position.x = (initialTouchLocation.x + touchLocation.x)
            print("paddle.position.x: \(paddle.position.x)")
            print("touchLocation.x: \(touchLocation.x)")
            print("initialTouchLocation.x: \(initialTouchLocation.x)")
            
//            let location = touch.location(in: self)
//            if paddle.contains(location) {
//                paddle.position.x = location.x
//            }
        }
    }
    
    func setupPaddle() {
        paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.allowsRotation = false
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
    
    func presentMenu() {
        print("presentMenu")
        let revealGameScene = SKTransition.fade(withDuration: 0.5)
        let goToMenuScene = MenuScene(size: self.size)
        goToMenuScene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(goToMenuScene, transition:revealGameScene)
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
            presentMenu()
        }
    }
}
