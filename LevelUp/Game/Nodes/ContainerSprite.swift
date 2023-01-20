//
//  Nodes.swift
//  DiamondsRush
//
//  Created by toha on 09.07.2021.
//

import SpriteKit

class ContainerSprite: SKNode {
    
    let ballTypes = itemNames

    let itemsPart = 3
    var index = 0
    var score = 0
    
    let cols: Int
    let rows: Int
    let itemSize: CGSize
    
    var winAction: (() -> ())?
    
    var selectedItem: BlinkItem?
    var allItems: [BlinkItem] {
        self.children.filter { $0 is BlinkItem }.compactMap { $0 as? BlinkItem }
    }
    
    var toppestItem: SKNode? {
        return children.max(by: { $1.position.y > $0.position.y })
    }
    
    var toppestY: CGFloat? {
        guard let toppestItem = toppestItem else { return nil }
        let toppestItemPosition = self.convert(toppestItem.position, to: self.parent ?? self)
        return toppestItemPosition.y
    }
    
    init(width: CGFloat, rows: Int, cols: Int = 5) {
        self.cols = cols
        let spacing: CGFloat = 12
        let allSpacing: CGFloat = CGFloat((cols - 1)) * spacing
        let itemWidth: CGFloat = (width - allSpacing) / CGFloat(cols)
        self.itemSize = .init(width: itemWidth, height: itemWidth)
        self.rows = rows
//        let size = CGSize(width: width, height: CGFloat(rows) * itemWidth)
        super.init()
        
        self.isUserInteractionEnabled = true
                
        let itemsCount: Int = cols * rows
        let itemsCountHalf: Int = itemsCount / 2
        var itemsIds = [String]()
        for _ in 0..<itemsCountHalf {
            let ballType = ballTypes.randomElement()!
            itemsIds.append(ballType)
            itemsIds.append(ballType)
        }
        itemsIds.shuffle()
        
        var col = 0
        var row = 0
        for i in 0..<itemsCount {
            let ballType = itemsIds[i]
            let ball = BlinkItem(size: itemSize, itemName: ballType)
            let xPosition: CGFloat = CGFloat(col) * (itemSize.width + spacing) - width / 2 + itemSize.width / 2
            let yPosition: CGFloat = -CGFloat(row) * (itemSize.height + spacing) - itemSize.height / 2
            ball.position = CGPoint(x: xPosition, y: yPosition)
            self.addChild(ball)
            
            col += 1
            if col >= cols {
                col = 0
                row += 1
            }
        }
        
        var actions = [SKAction]()
        actions.append(.wait(forDuration: 0.02))
        allItems.forEach { item in
            item.itemNode.setScale(0.0)
            actions.append(.run { item.itemNode.scaleToNormal() })
            actions.append(.wait(forDuration: 0.05))
        }
        self.run(.sequence(actions))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let position = touches.first?.location(in: self) else { return }
        guard let tappedBall = nodes(at: position).first(where: { $0 is BlinkItem }) as? BlinkItem else { return }
//        print(tappedBall.position)
        if selectedItem == nil {
            tappedBall.highlight()
            self.selectedItem = tappedBall
        } else if tappedBall.name == selectedItem?.name {
            selectedItem?.animaterRemoving()
            tappedBall.animaterRemoving()
            selectedItem = nil
            if allItems.count < 2 {
                winAction?()
            }
        } else {
            tappedBall.highlight()
            self.run(.wait(forDuration: 0.2)) {
                tappedBall.disable()
                self.selectedItem?.disable()
                self.selectedItem = nil
            }
        }
    }
    
    func changeColors() {
//        allItems.enumerated().forEach {
//            let isColorful = $0.offset % itemsPart == index
//            $0.element.isColorful = isColorful
//        }
//        index += 1
//        if index == itemsPart {
//            index = 0
//        }
    }
    
    func boomAllItems() {
        var actions = [SKAction]()
        allItems.forEach { item in
            actions.append(.run { item.animaterRemoving() })
            actions.append(.wait(forDuration: 0.02))
        }
        self.run(.sequence(actions))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  BlinkItem.swift
//  LevelUp
//
//  Created by 1 on 12.12.2021.
//

//import SpriteKit

//class BlinkItem: SKSpriteNode {
//        
//    let itemTexture: SKTexture
//    let bgTexture: SKTexture = .init(imageNamed: "rectAlpha")
//    let bgSelectedTexture: SKTexture = .init(imageNamed: "rectAlphaSelected")
//    let bgTextureHidden: SKTexture = .init(imageNamed: "rect")
//    
//    init(size: CGSize, itemName: String? = nil) {
//        let name = itemName == nil ? itemNames.randomElement()! : itemName!
//        self.itemTexture = SKTexture(imageNamed: name)
//        super.init(texture: bgTexture, color: .clear, size: size)
//        
//        self.zPosition = 1
//        self.name = name
//        
//        let itemNode = SKSpriteNode(texture: itemTexture, color: .clear, size: size)
//        itemNode.zPosition = 1
//        self.addChild(itemNode)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    var isSelected = false {
//        didSet {
//            self.texture = isSelected ? bgSelectedTexture : bgTexture
//        }
//    }
//    
//    func animaterRemoving() {
//        if let particles = SKEmitterNode(fileNamed: "exp.sks") {
//            particles.zPosition = 0
//            particles.position = self.position //.init(x: self.frame.width / 2, y: 0)
//            self.parent?.addChild(particles)
//            self.removeFromParent()
//                        
//            let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()])
//            particles.run(removeAfterDead)
//        }
//    }
//    
//    func highlight() {
//        self.isUserInteractionEnabled = true
//        isSelected = true
//    }
//    
//    func disable() {
//        isSelected = false
//        self.isUserInteractionEnabled = false
//    }
//}
