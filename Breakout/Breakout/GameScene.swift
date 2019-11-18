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
    
    let ballSpeed = 50
    var touched = false
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var touchToStartLabel: SKLabelNode!
    var audioPlayer: AVAudioPlayer!
    var initialTouchLocation = CGPoint()
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        setupSpriteNode()
        setupAudioPlayer()
        setupWorld(view: view)        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touched == false {
            touched = true
            setupBall()
            touchToStartLabel.isHidden = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let previousTouchLocation = touch.previousLocation(in: self)
        let paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        var newXPos = paddle.position.x + (touchLocation.x - previousTouchLocation.x)
        newXPos = max(newXPos, (-self.size.width + paddle.size.width)/2)
        newXPos = min(newXPos, (self.size.width - paddle.size.width)/2)
        paddle.position = CGPoint(x: newXPos, y: paddle.position.y)
    }
    
    func setupBall() {
        ball.physicsBody?.applyImpulse(CGVector(dx: ballSpeed, dy: ballSpeed))
    }
    
    func setupWorld(view: SKView) {
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        self.physicsWorld.contactDelegate = self
    }
    
    func setupSpriteNode() {
        ball = (self.childNode(withName: "Ball") as! SKSpriteNode)
        paddle = (self.childNode(withName: "Paddle") as! SKSpriteNode)
        scoreLabel = (self.childNode(withName: "Score") as! SKLabelNode)
        touchToStartLabel = (self.childNode(withName: "StartLabel") as! SKLabelNode)
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
