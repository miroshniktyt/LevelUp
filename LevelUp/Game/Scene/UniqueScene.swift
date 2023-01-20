//
//  FindUniqueGameScene.swift
//  StartingNewScene
//
//  Created by Artemius on 15.12.2021.
//


import SpriteKit
import GameplayKit
import UIKit

class UniqueScene: Scene {
    
    enum GameState { case prepearing, playing, over }
    
    var gameState: GameState = .prepearing
    var progress: ProgressBar?
    var gameNodes: [BlinkItem] = []
//    let levelLable = SKLabelNode()
//    let tapToScreenNode = SKLabelNode()
//    let aboutLable = SKLabelNode()
    var uniqueName: String = ""
//    var isTraining: Bool?
    
    override func didMove(to view: SKView) {
        progress = ProgressBar(width: self.frame.width - 128)
        progress?.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 102)
        progress?.zPosition = 2
        addChild(progress!)
        
        threeTwoOneGo() {
            self.gameSettings()
        }
    }
    
    public func gameSettings() {
//        levelLable.removeFromParent()
//        tapToScreenNode.removeFromParent()
//        aboutLable.removeFromParent()
        childSettings()
        gameState = .playing
    }
        
    private func childSettings() {
        var itemNames = LevelUp.itemNames.shuffled()
        let numberOfItems = level + 4
        let numberOfNonUnique = numberOfItems - 1
        let maxNumberOfPairs = itemNames.count - 1
        let numberOfPairs = min((numberOfNonUnique / 2), maxNumberOfPairs)
        let numberOfAdditianalElements = numberOfNonUnique - numberOfPairs * 2
        
        // choose unique element and delete him from array of item names
        uniqueName = itemNames.randomElement()!
        for i in 0..<itemNames.count {
            if itemNames[i] == uniqueName {
                itemNames.remove(at: i)
                break
            }
        }
        // duplicate symbols to get wanted count of elements
        let pairsNames = itemNames[0..<numberOfPairs]
        var arr = pairsNames + pairsNames
        for _ in 0..<numberOfAdditianalElements {
            let randomElement = arr.randomElement()!
            arr.append(randomElement)
        }
        arr.append(uniqueName)
        
        for i in 0..<arr.count {
            let symbolName = arr[i]
            let symbol = BlinkItem(size: .init(width: 16, height: 16), itemName: symbolName)
            symbol.zPosition = 2
            gameNodes.append(symbol)
        }
        
        setItemsAsGrid(items: gameNodes, margins: 64, spacing: 8)
        
        animateAllItems()
    }
    
    // TODO DRY
    private func animateAllItems() {
//        gameNodes.forEach { $0.isHidden = true }
        gameNodes.forEach { $0.setScale(0) }
        var actions = [SKAction]()
        gameNodes.forEach { item in
//            actions.append(.run { item.isHidden = false })
            actions.append(.run { item.scaleToNormal() })
            actions.append(.wait(forDuration: 0.05))
        }
        actions.append(SKAction.run({
            self.progress?.start(duration: 7) {
                self.gameOver(isWinner: false)
            }
        }))
        self.run(.sequence(actions))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        switch gameState {
        case .prepearing:
            print("prepearing")
        case .playing:
            guard let position = touches.first?.location(in: self) else { return }
            guard let touchedNode = nodes(at: position).first(where: { $0 is BlinkItem }) as? BlinkItem else { return }
            let result = touchedNode.name == uniqueName
            self.gameOver(isWinner: result)
        case .over:
            print("over")
        }
    }
    
    func gameOver(isWinner: Bool) {
        guard gameState == .playing else { return }
        gameState = .over
        
        if isWinner {
            gameNodes.forEach {
                if $0.name != uniqueName {
                    $0.run(.fadeOut(withDuration: 0.5))
                } else {
                    $0.isSelected = true
                }
            }
        } else {
            gameNodes.forEach {
                if $0.name != uniqueName {
                    $0.animaterRemoving()
                }
            }
        }
        
        let delay = isWinner ? 1.5 : 2
        self.run(.wait(forDuration: delay)) {
            self.gameOverDelegate?.gameOver(isWinner: isWinner)
        }
    }
    
    deinit {
        print("deinited")
    }
}

extension SKScene {
    func setItemsAsGrid(items: [SKSpriteNode], margins: CGFloat, spacing: CGFloat) {
        
        var matrixSize = 0
        let sqr = Double(items.count).squareRoot()
        if sqr - Double(Int(sqr)) > 0 {
            matrixSize = Int(sqr) + 1
        } else {
            matrixSize = Int(sqr)
        }
        
        let allSpasingWidth = spacing * CGFloat(matrixSize - 1)
        let allMarginsWidth = margins * 2
        let itemSize = (self.frame.width - allSpasingWidth - allMarginsWidth ) / CGFloat(matrixSize)
        var points: [CGPoint] = []
        var xPos = margins + itemSize / 2 - frame.width / 2
        var yPos = (self.frame.height - itemSize * CGFloat(matrixSize) - spacing * CGFloat(matrixSize - 1)) / 2 + itemSize / 2
        
        for _ in 1...matrixSize {
            for _ in 1...matrixSize {
                points.append(CGPoint(x: xPos, y: yPos))
                xPos += itemSize + spacing
            }
            xPos = margins + itemSize / 2 - frame.width / 2
            yPos += itemSize + spacing
        }
        
        let shuffledPositions = points.shuffled()
        for i in 0...items.count - 1 {
            items[i].position = shuffledPositions[i]
            items[i].size = CGSize(width: itemSize, height: itemSize)
            addChild(items[i])
        }
    }

}
