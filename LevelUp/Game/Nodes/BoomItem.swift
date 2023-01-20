//
//  Ball.swift
//  FieryNumbers
//
//  Created by Fortune on 12.02.2021.
//

import SpriteKit

//extension BlinkItem {
//    var isBomb: Bool { planets.contains(self.name ?? "") }
//    
//    convenience init(size: CGSize, isBomb: Bool) {
//        let name = isBomb ? planets.randomElement()! : stars.randomElement()!
//        self.init(size: size, itemName: name)
//    }
//}

class BoomItem: SKSpriteNode {
    
    var isBoom: Bool
    
    let itemNode: SKSpriteNode
    
    let bgTextureHidden: SKTexture = .init(imageNamed: "rect")
    let bgTextureShown = SKTexture(imageNamed: "rectAlpha")
    
    init(size: CGSize, isBoom: Bool) {
        self.isBoom = isBoom
        
        let itemName: String
        if isBoom {
            itemName = planets.randomElement()!
        } else {
            itemName = stars.randomElement()!
        }
        
        let itemTexture = SKTexture(imageNamed: itemName)
        self.itemNode = SKSpriteNode(texture: itemTexture, color: .clear, size: size.applying(.init(scaleX: 0.8, y: 0.8)))
        
        super.init(texture: bgTextureHidden, color: .clear, size: size)
        
        itemNode.zPosition = 1
//        itemNode.isUserInteractionEnabled = true
        self.addChild(itemNode)
        
//        self.physicsBody = .init(circleOfRadius: self.frame.width / 2)
        self.physicsBody = .init(texture: bgTextureHidden, size: self.size)
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.friction = 0.5 //TODO
        self.physicsBody?.restitution = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isShown: Bool = false {
        didSet {
            itemNode.isHidden = !isShown
            self.texture = isShown ? bgTextureShown : bgTextureHidden
        }
    }
    
    func explode() {
        let soundAction = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
        self.run(soundAction)
        
        if let particles = SKEmitterNode(fileNamed: "exp.sks") {
            particles.position = self.position
            parent?.addChild(particles)

            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
            particles.run(removeAfterDead)
        }
        self.isHidden = true
    }
    
    func win() {
//        if let particles = SKEmitterNode(fileNamed: "coins") {
//            particles.position = self.position
//            let textureName = ["item2", "item4", "item5"].randomElement()
//            particles.particleTexture = .init(imageNamed: textureName!)
//            particles.zPosition = 3
//            self.parent?.addChild(particles)
//        }
//        self.removeFromParent()
        let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.5)
        let act = SKAction.repeat(rotateAction, count: 3)
        act.timingMode = .easeOut
        self.run(act)
    }
    
}
