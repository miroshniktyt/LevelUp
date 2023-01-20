//
//  InfoScene.swift
//  LevelUp
//
//  Created by 1 on 25.01.2022.
//

import SpriteKit

class InfoScene: SKScene {
    var gameName: String?
    var gameInfo: String?
    
    var tapAction: (() -> ())?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        
//        threeTwoOneGo(node: self) {
//            print("")
//        }
        
        let infoLabel = InAppSKLabel(weight: .thin)
        infoLabel.fontSize = 16
        infoLabel.text = gameInfo
        infoLabel.position.y = frame.midY
        infoLabel.position.x = frame.midX
        infoLabel.verticalAlignmentMode = .center
        infoLabel.preferredMaxLayoutWidth = self.frame.width - 32
        infoLabel.numberOfLines = 0
        
        let nameLabel = InAppSKLabel(weight: .heavy)
        nameLabel.fontSize = 32
        nameLabel.text = gameName
        nameLabel.position.y = infoLabel.frame.maxY + 32
        nameLabel.position.x = frame.midX
        nameLabel.verticalAlignmentMode = .bottom
        
        let startLabel = InAppSKLabel()
        startLabel.fontSize = 16
        if #available(iOS 13.0, *) {
            startLabel.fontColor = .link
        } else {
            // Fallback on earlier versions
        }
        startLabel.text = "TAP ANYWHERE TO START"
        startLabel.position.y = infoLabel.frame.minY - 32
        startLabel.position.x = frame.midX
        startLabel.verticalAlignmentMode = .top
        startLabel.run(.repeatForever(.sequence([
            .scale(to: 0.9, duration: 1),
            .scale(to: 1, duration: 1),
        ])))
        
        [infoLabel, nameLabel, startLabel].forEach { self.addChild($0) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        var actions = [SKAction]()
//        self.children.reversed().forEach { node in
//            actions.append(.run {
//                node.removeFromParent()
//            })
//            actions.append(.wait(forDuration: 0.25))
//        }
//        actions.append(.run {
//            self.tapAction!()
//        })
//        self.run(.sequence(actions))
        
        self.tapAction!()

    }
    
    deinit {
        print("deinited")
    }
}
