//
//  ProgressBar.swift
//  FindOdd
//
//  Created by Mac on 19.08.2021.
//

import SpriteKit

class ProgressBar : SKNode {
    
    var progressBar : SKCropNode
    
    init(width: CGFloat) {
//        let baseImage = "Time frame"
//        let coverImage = "Time indicator"
        let color = UIColor.white
        progressBar = SKCropNode()
        super.init()
        let bgSize = CGSize(width: width, height: 16)
        
        let bgRect = CGRect(x: -bgSize.width / 2, y: -bgSize.height / 2, width: bgSize.width, height: bgSize.height)
        let bgSprite = SKShapeNode(rect: bgRect, cornerRadius: bgRect.height / 2)
        bgSprite.fillColor = .clear
        bgSprite.strokeColor = color
        bgSprite.lineWidth = 1
        self.addChild(bgSprite)
        
        let fillRect = bgRect
        let filledSprite = SKShapeNode(rect: fillRect, cornerRadius: bgRect.height / 2)
        filledSprite.fillColor = color
        filledSprite.strokeColor = color
        progressBar.addChild(filledSprite)
        progressBar.maskNode = SKSpriteNode(
            color: .white,
            size: CGSize(width: bgSize.width * 2, height: bgSize.height * 2))

        progressBar.maskNode?.position = CGPoint(x: -bgSize.width / 2, y: -bgSize.height / 2)
        progressBar.zPosition = 2
        self.addChild(progressBar)
    }
    
    func start(duration: Double, complition: @escaping (() -> ())) {
        let action = SKAction.scaleX(to: 0, duration: duration);
        progressBar.maskNode?.run(action, completion: {
            complition()
        })
    }
    
    func setXProgress(xProgress : CGFloat){
        var value = xProgress
        if xProgress < 0{
            value = 0
        }
        if xProgress > 1 {
            value = 1
        }
        progressBar.maskNode?.xScale = value
    }

    func setYProgress(yProgress : CGFloat){
        var value = yProgress
        if yProgress < 0{
            value = 0
        }
        if yProgress > 1 {
            value = 1
        }
        progressBar.maskNode?.yScale = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
