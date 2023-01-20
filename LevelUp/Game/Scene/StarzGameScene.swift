//
//  GameScene.swift
//  DiamondsRush
//
//  Created by toha on 08.07.2021.
//

import SpriteKit
import GameplayKit

class StarzGameScene: Scene {
    
    enum GameState { case prepearing, playing, over }
    
    var gameState: GameState = .prepearing
    
    var container: ContainerSprite!
        
    lazy var dangerZone: SKShapeNode = {
        let node = SKShapeNode(rectOf: .init(width: self.frame.width, height: 32))
        node.fillColor = .systemRed
        node.strokeColor = .systemRed
        return node
    }()
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        self.physicsWorld.gravity = .zero
        
        dangerZone.position.y = frame.maxY
        self.addChild(dangerZone)
        
        self.run(.repeatForever(.sequence([
            .run { self.dangerZone.isHidden = false },
            .wait(forDuration: 0.75),
            .run { self.dangerZone.isHidden = true },
            .wait(forDuration: 0.25),
            .run { self.checkForTouch() }
        ])))
        
        let rows = 8 + level * 2
        let cols = level < 2 ? 4 : 5
        container = ContainerSprite(width: self.frame.width - 32, rows: rows, cols: cols)
        container.winAction = { self.win() }
        container.position.y = self.frame.midY
        addChild(container)

        threeTwoOneGo() {
            self.start()
        }
    }
    
    func start() {
        let baseDy = (self.frame.height / 300)
        let dy: CGFloat = baseDy + (0.1 * CGFloat(level) * baseDy)
        let moveAction = SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: dy), duration: 0.2))
        self.container.run(moveAction)
        
        gameState = .playing
    }
    
    func win() {
        gameOverDelegate?.gameOver(isWinner: true)
    }
    
    func lose() {
        container.boomAllItems()
        gameState = .over
        self.run(.wait(forDuration: 1.5)) {
            self.gameOverDelegate?.gameOver(isWinner: false)
        }
    }
        
    override func update(_ currentTime: TimeInterval) {
        guard gameState == .playing else { return }
    }
    
    func checkForTouch() {
        if container.calculateAccumulatedFrame().maxY > dangerZone.frame.minY {
            lose()
        }
    }
    
    deinit {
        print("deinited")
    }
}
