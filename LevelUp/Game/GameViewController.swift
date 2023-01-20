//
//  GameViewController.swift
//  Buffalo Up
//
//  Created by toha on 19.03.2021.
//

import UIKit
import SpriteKit
import GameKit

protocol GameOverable: AnyObject {
    func gameOver(isWinner: Bool)
}

class GameViewController: UIViewController, GameOverable {
    
    var game: GameItem?
        
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var gameView: SKView!
        
    private var viewFirstDidLayoutSubviews = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !viewFirstDidLayoutSubviews {
            viewFirstDidLayoutSubviews = true
            setYouWin()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.setGame()
            }
            print("viewDidLayoutSubviews")
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setGame() {
        guard let game = game else { return }
        
        let sceanSize = gameView.bounds.size
        let gameType = game.sceanType
        let scene = gameType.init(size: sceanSize) as! Scene
        
        scene.gameOverDelegate = self
        let level = Level.shared.level
        scene.level = level
        scene.backgroundColor = .clear
        scene.anchorPoint = .init(x: 0.5, y: 0.0)
        scene.scaleMode = .aspectFill
        
        gameView.presentScene(scene)
//        gameView.presentScene(scene)
//        gameView.showsPhysics = true
        gameView.ignoresSiblingOrder = true
        gameView.allowsTransparency = true
    }
    
    func gameOver(isWinner: Bool) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "finalPractice") as! PlayFinalViewController
        vc.isWinner = isWinner
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func setYouWin() {
        let sceanSize = gameView.bounds.size
        let scene = SKScene(size: sceanSize)
        scene.backgroundColor = .clear
        
        let startLabel = InAppSKLabel(weight: .black)
        startLabel.position = .init(x: scene.frame.midX, y: scene.frame.midY)
        startLabel.fontSize = 32
        let level = Level.shared.level
        startLabel.text = "LEVEL \(level)"
        startLabel.zPosition = 65
        startLabel.horizontalAlignmentMode = .center
        startLabel.verticalAlignmentMode = .bottom
        scene.addChild(startLabel)
        
        gameView.presentScene(scene)
    }
}

