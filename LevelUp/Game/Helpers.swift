//
//  InAppButton.swift
//  digger
//
//  Created by toha on 06.03.2021.
//

import SpriteKit

class InAppSKLabel: SKLabelNode {
    
    let weight: UIFont.Weight
    
    init(weight: UIFont.Weight = .regular) {
        self.weight = weight
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        didSet {
            let font = UIFont.systemFont(ofSize: self.fontSize, weight: weight)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            self.attributedText = NSAttributedString(string: self.text ?? "", attributes: [
                .font: font,
                .foregroundColor: self.fontColor,
                .paragraphStyle: paragraphStyle
            ])
        }
    }
}

class InAppButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        SoundManager.sharedInstance.play(sound: .select)
        super.touchesBegan(touches, with: event)
    }
}

func printFonts() {
    for family in UIFont.familyNames {
        for names in UIFont.fontNames(forFamilyName: family) {
            print("== \(names)")
        }
    }
}

let inAppFont = "SFUI-Bold"// "AvenirNext-Heavy"

extension SKNode {
    var positionInScene: CGPoint? {
        if let scene = scene, let parent = parent {
            return parent.convert(position, to:scene)
        } else {
            return nil
        }
    }
}

extension SKSpriteNode {
    func scaleToNormal() {
        self.run(.scale(to: 1.0, duration: 0.5))
    }
}

extension SKScene {
    func threeTwoOneGo(completion: @escaping () -> Void) {
        let startLabel = InAppSKLabel(weight: .black)
        startLabel.position = .init(x: self.frame.midX, y: self.frame.midY)
        startLabel.zPosition = 128
        startLabel.horizontalAlignmentMode = .center
        startLabel.verticalAlignmentMode = .center
        startLabel.fontSize = 96
        startLabel.text = "3"
    //    startLabel.fontName = inAppFont
        startLabel.fontColor = .white
        self.addChild(startLabel)
        
        let seq = SKAction.sequence([
            .wait(forDuration: 1),
            .run { startLabel.text = "2" },
            .wait(forDuration: 1),
            .run { startLabel.text = "1" },
            .wait(forDuration: 1),
            .removeFromParent()
        ])
        startLabel.run(seq) {
            completion()
        }
    }
}
