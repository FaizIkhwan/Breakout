//
//  MenuScene.swift
//  Breakout
//
//  Created by Faiz Ikhwan on 14/11/2019.
//  Copyright © 2019 Faiz Ikhwan. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let background = SKSpriteNode(color: .red, size: self.size)
        background.position = CGPoint(x: 0, y: 0)
        addChild(background)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let revealGameScene = SKTransition.fade(withDuration: 0.5)
        let goToGameScene = GameScene(size: self.size)
        goToGameScene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(goToGameScene, transition:revealGameScene)
    }
}
