//
//  GameScene.swift
//  FirstGame
//
//  Created by Prince$$ Di on 28.08.2021.
//
import UIKit
import SpriteKit

class BlinkScene: Scene {
        
    let bg2 = SKSpriteNode(imageNamed: "bg2")
    var sprites = [BlinkItem]()
    
    let uniqueItem = "unique"
    lazy var itemSize = CGSize(width: frame.width / 6, height: frame.width / 6)
    var didStartGame: Bool = false
    
    override func didMove(to view: SKView) {
//        let labelLevel = SKLabelNode()
//        labelLevel.fontName = "AvenirNext-Bold"
//        labelLevel.fontSize = 50
//        labelLevel.text = "LEVEL: \(level)"
//        labelLevel.position = CGPoint(x: frame.midX, y: frame.midY + 60)
//        labelLevel.zPosition = 11
//        labelLevel.addStroke(color: .purple, width: 5)
//        addChild(labelLevel)
        
        spawnItems()
        animateAllItems()
        threeTwoOneGo() {
            self.didStartGame = true
            self.pulseAllItems()
        }
    }
    
    private func animateAllItems() {
//        sprites.forEach { $0.isHidden = true }
//        var actions = [SKAction]()
        sprites.forEach { item in
            let randomPosition = item.position
            let startPosition = CGPoint(x: frame.midX, y: frame.minY)
            item.position = startPosition
            item.run(.move(to: randomPosition, duration: 0.5))
        }
//        self.run(.group(actions))
    }
    
    func spawnItems() {
        let numberOfItems = 5 + level
        
        for _ in 0..<numberOfItems {
            let newSprite = BlinkItem(size: itemSize)
            newSprite.position = randomPosition()
            self.addChild(newSprite)
            
            var isInterectsWithOthers: Bool {
                var isInterects = false
                for sprite in sprites {
                    if sprite.intersects(newSprite) {
                        isInterects = true
                    }
                }
                return isInterects
            }
            
            while isInterectsWithOthers {
                newSprite.position = randomPosition()
            }
            sprites.append(newSprite)
        }
        let randomItem = sprites.randomElement()!
        randomItem.name = uniqueItem
    }
    
    func randomPosition() -> CGPoint {
        let x = CGFloat.random(in: frame.minX + itemSize.width...frame.maxX - itemSize.width)
        let y = CGFloat.random(in: frame.minY + itemSize.width...frame.maxY - itemSize.width)
        return CGPoint(x: x, y: y)
    }
    
    func pulseAllItems() {
        var actions = [SKAction]()
        let delay = 0.6
        actions.append(.wait(forDuration: delay))

        for sprite in sprites {
            if sprite.name != uniqueItem {
                actions.append(.run {
                    sprite.isSelected = true
                })
                actions.append(.wait(forDuration: delay))
                actions.append(.run {
                    sprite.isSelected = false
                })
                actions.append(.wait(forDuration: delay / 2))
            }
        }
        
        self.run(.sequence(actions))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if didStartGame {
            let positionInScene = touches.first!.location(in: self)
            guard let touchedNode = nodes(at: positionInScene).first(where: { $0 is BlinkItem }) as? BlinkItem else { return }
            let tappedName = touchedNode.name
            let isWinner = tappedName == uniqueItem
            
            sprites.forEach {
                if $0.name != uniqueItem {
                    if isWinner {
                        $0.animaterRemoving()
                    } else {
                        $0.removeFromParent()
                    }
                } else {
                    $0.highlight()
                }
            }
            
            self.run(.wait(forDuration: 1)) {
                self.gameOverDelegate?.gameOver(isWinner: isWinner)
            }
        }
    }
    
    deinit {
        print("deinited")
    }
}
