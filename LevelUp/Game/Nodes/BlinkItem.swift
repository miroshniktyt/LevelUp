//
//  BlinkItem.swift
//  LevelUp
//
//  Created by 1 on 12.12.2021.
//

import SpriteKit

class BlinkItem: SKSpriteNode {
    
    // made for uniqueScene to keep itemNode.size normal after changing self.size
    override var size: CGSize {
        didSet {
            itemNode.size = self.size
        }
    }
        
    let itemTexture: SKTexture
    let itemNode: SKSpriteNode
    let bgTexture: SKTexture = .init(imageNamed: "rectAlpha")
    let bgSelectedTexture: SKTexture = .init(imageNamed: "rectAlphaSelected")
//    let bgTextureHidden: SKTexture = .init(imageNamed: "rect")
    
    init(size: CGSize, itemName: String? = nil) {        
        let name = itemName == nil ? itemNames.randomElement()! : itemName!
        self.itemTexture = SKTexture(imageNamed: name)
        self.itemNode = SKSpriteNode(texture: itemTexture, color: .clear, size: size)
        super.init(texture: bgTexture, color: .clear, size: size)
        
        self.zPosition = 1
        self.name = name
        
        itemNode.zPosition = 1
        self.addChild(itemNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isSelected = false {
        didSet {
            self.texture = isSelected ? bgSelectedTexture : bgTexture
        }
    }
    
    func animaterRemoving() {
        if let particles = SKEmitterNode(fileNamed: "exp.sks") {
            particles.zPosition = 0
            particles.position = self.position //.init(x: self.frame.width / 2, y: 0)
            self.parent?.addChild(particles)
            self.removeFromParent()
                        
            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()])
            particles.run(removeAfterDead)
        }
    }
    
    func highlight() {
        self.isUserInteractionEnabled = true
        isSelected = true
    }
    
    func disable() {
        isSelected = false
        self.isUserInteractionEnabled = false
    }
}
