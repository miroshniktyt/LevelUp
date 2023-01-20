//
//  SqnsViewController.swift
//  LevelUp
//
//  Created by 1 on 15.12.2021.
//

import SpriteKit

class SqnsViewController: BaseVC, GameOverable {
    
    private var currentGameIndex = 0
    var games = [GameItem]()
    var currentGameItem: GameItem { games[currentGameIndex] }
    
    @IBOutlet weak var levelsIndicatorView: LevelsIndicatorView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var gameView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        games.shuffle()
        levelsIndicatorView.levels = games.count
    }
        
    private var viewFirstDidLayoutSubviews = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !viewFirstDidLayoutSubviews {
            viewFirstDidLayoutSubviews = true
            
            gameView.showsPhysics = false
            gameView.backgroundColor = .clear
            gameView.ignoresSiblingOrder = true
            gameView.allowsTransparency = true
            
            setNameAndGame()
//            setGame()
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setNameAndGame() {
        let name = currentGameItem.name
        let scene = getScene(withName: name)
        scene.tapAction = {
            self.setGame()
        }
        gameView.presentScene(scene)
        
                
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.setGame()
//        }
    }
    
    func setGame() {
        let level = Level.shared.level
        
        let sceanSize = gameView.bounds.size
        let gameType = currentGameItem.sceanType
        let scene = gameType.init(size: sceanSize) as! Scene
        scene.gameOverDelegate = self
        scene.level = level
        scene.anchorPoint = .init(x: 0.5, y: 0.0)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        
        gameView.presentScene(scene)
        gameView.isHidden = false
    }
    
    func gameOver(isWinner: Bool) {
        
        let wasLastGame = games.count == (currentGameIndex + 1)
        let playNextGame = !wasLastGame && isWinner
//        let didCompleteAll = wasLastGame && didWin
        
        if playNextGame {
            setNextGame()
        } else {
            presentFinal(isWinner: isWinner)
        }
    }
    
    func presentFinal(isWinner: Bool) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "finalSqns") as! PlayFinalViewController
        vc.isWinner = isWinner
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func setNextGame() {
        currentGameIndex += 1
//        setGame()
        setYouWin()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.levelsIndicatorView.levelsDone = self.currentGameIndex
            self.setNameAndGame()
        }
    }
    
    func getScene(withName: String) -> InfoScene {
        let sceanSize = gameView.bounds.size
        let scene = InfoScene(size: sceanSize)
        scene.gameName = currentGameItem.name
        scene.gameInfo = currentGameItem.gameInfo
        
        return scene
    }
    
    func setYouWin() {
        let sceanSize = gameView.bounds.size
        let scene = SKScene(size: sceanSize)
        scene.backgroundColor = .clear
        
        let startLabel = InAppSKLabel(weight: .black)
        startLabel.position = .init(x: scene.frame.midX, y: scene.frame.midY)
        startLabel.fontColor = .systemGreen
        startLabel.fontSize = 88
        startLabel.text = "YOU WIN"
        startLabel.zPosition = 65
        startLabel.horizontalAlignmentMode = .center
        startLabel.verticalAlignmentMode = .center
        scene.addChild(startLabel)
        
        startLabel.setScale(0.01)
        let appear = SKAction.group([SKAction.scale(to: 0.5, duration: 0.25), SKAction.fadeIn(withDuration: 0.25)])
        let disappear = SKAction.group([SKAction.scale(to: 1, duration: 0.25), SKAction.fadeOut(withDuration: 0.25)])
        let sequence = SKAction.sequence([appear, SKAction.wait(forDuration: 0.25), disappear, SKAction.removeFromParent()])
        startLabel.run(sequence)
        
        gameView.presentScene(scene)
    }
}

class LabelScene: SKScene {
    
}
