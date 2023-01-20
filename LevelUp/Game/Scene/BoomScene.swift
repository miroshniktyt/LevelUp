//
//  GameScene.swift
//  FieryNumbers
//
//  Created by Fortune on 10.02.2021.
//

import SpriteKit

class BoomScene: Scene {
                        
    let impuls = 40
    
    var coef: CGFloat { level > 4 ? 7.5 : 6.5 }
    
    enum GameState { case prepearing, waitingForSwipe, isFalling, poused }
        
    var gameState: GameState = .prepearing
    
    let startLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        startLabel.fontSize = 16
        startLabel.position = CGPoint(x: frame.midX, y: frame.minY + 64 + bottomPadding)
        startLabel.text = "TAP  TO  START"
        startLabel.zPosition = 100
        startLabel.horizontalAlignmentMode = .center
        
        physicsWorld.gravity = .init(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: .init(top: 0, left: 0, bottom: 0, right: 0)))
        
        setupNewGame()
    }
    
    func setupNewGame() {

        let numberOfBalls = level + 4
        for i in 0..<numberOfBalls {
            let side = self.frame.width / coef
            let size = CGSize(width: side, height: side)
            let ballsPerBonus = 3
            let isBoom = i % ballsPerBonus == 0
            let item = BoomItem(size: size, isBoom: isBoom)
            items.append(item)
        }
        
        items.shuffle()
        
        var sequence = [SKAction]()
        sequence.append(SKAction.wait(forDuration: 0.5))
        for item in items {
            item.isShown = true
            sequence.append(SKAction.run {
                item.position = .init(x: self.frame.midX + .random(in: -10...10), y: self.frame.midY + .random(in: -10...10))
                self.addChild(item)
            })
            sequence.append(SKAction.wait(forDuration: 0.2))
        }
        sequence.append(.run {
//            self.addChild(self.startLabel)
            self.gameState = .waitingForSwipe
        })
        
        self.run(SKAction.sequence(sequence))
    }
    
    func dropTheBalls() {
        var randomImpuls: CGVector { .init(dx: .random(in: -impuls...impuls), dy: .random(in: -impuls...impuls)) }

        self.items.forEach { $0.isShown = false }
        
        self.run(.sequence([
            .wait(forDuration: 1),
            .run {
                self.items.forEach { $0.physicsBody?.applyImpulse(randomImpuls) }
                self.explode()
            },
            .wait(forDuration: 4),
            .run {
                self.items.forEach { $0.physicsBody = nil }
                self.gameState = .poused
            }
        ]))
    }
    
    var items: [BoomItem] = []
    
    var isComplete: Bool {
        let aimItems = items.filter { !$0.isBoom }
        let openedAimItems = items.filter { !$0.isBoom && $0.isShown }
        return aimItems.count == openedAimItems.count
    }
    
    func wrongTapped() {
        let soundAction = SKAction.playSoundFileNamed("wrong.mp3", waitForCompletion: false)
        self.run(soundAction)
        
        var sequence = [SKAction]()
        sequence.append(SKAction.wait(forDuration: 0.5))
        for ball in items {
            if ball.isBoom {
                ball.isShown = true
                sequence.append(SKAction.run { ball.explode() })
            } else {
//                ball.removeFromParent()
            }
        }
        sequence.append(SKAction.run { self.lose() })
        self.run(SKAction.sequence(sequence))
    }
    
    func explode() {
        if let particles = SKEmitterNode(fileNamed: "Explosion") {
            particles.position = .init(x: frame.midX, y: frame.midY)
            particles.zPosition = -1
            self.addChild(particles)

            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
            particles.run(removeAfterDead)
        }
    }
    
    func correctTapped() {
        let soundAction = SKAction.playSoundFileNamed("correct.wav", waitForCompletion: false)
        self.run(soundAction)
        if isComplete {
            items.forEach {
                if !$0.isBoom {
                    $0.win()
                } else {
                    $0.removeFromParent()
                }
            }
            self.win()
        }
    }
    
    func win() {
        items.forEach {
            if !$0.isBoom { $0.win() }
        }
        self.run(.wait(forDuration: 1)) {
            self.gameOverDelegate?.gameOver(isWinner: true)
        }
    }
    
    func lose() {
        self.run(.wait(forDuration: 1)) {
            self.gameOverDelegate?.gameOver(isWinner: false)
        }
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        switch gameState {
        case .prepearing:
            print("wait...")
        case .waitingForSwipe:
            startLabel.removeFromParent()
            dropTheBalls()
            gameState = .isFalling
        case .isFalling:
            print("wait...")
        case .poused:
            guard let position = touches.first?.location(in: self) else { return }
            guard let tappedBall = nodes(at: position).first(where: { $0 is BoomItem }) as? BoomItem else {
                return
            }
            tappedBall.isShown = true
            if tappedBall.isBoom {
                wrongTapped()
            } else {
                correctTapped()
            }
        }
    }
    
    deinit {
        print("deinited")
    }
}
