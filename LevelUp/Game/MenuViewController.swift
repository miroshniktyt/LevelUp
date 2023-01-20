//
//  MenuViewController.swift
//  LevelUp
//
//  Created by toha on 06.09.2021.
//

import UIKit

class MenuViewController: BaseVC {
    
//    var scenes: [Scene.Type] = [
//        BoomScene.self,
//        BlinkScene.self,
//        StarzGameScene.self,
//        UniqueScene.self
//    ]
    
    var items: [GameItem] = [
        GameItem.init(
            name: "MEMORY UP",
            gameInfo: "COLLECT ALL THE STARS\nBUT AVOID THE ASTEROIDS",
            sceanType: BoomScene.self
        ),
        GameItem.init(
            name: "CONCENTRATION UP",
            gameInfo: "FIND THE ITEM THAT DID NOT BLINK",
            sceanType: BlinkScene.self
        ),
        GameItem.init(
            name: "SPEED UP",
            gameInfo: "POP ALL THE PAIR ITEMS\nBEFORE IT TOUCHES RED",
            sceanType: StarzGameScene.self
        ),
        GameItem.init(
            name: "REACTION UP",
            gameInfo: "FIND THE UNIQUE ITEM",
            sceanType: UniqueScene.self
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .black
        
        let stack = UIStackView()
        self.view.addSubview(stack)
        stack.spacing = 16
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let level = Level.shared.level
        let playButton = UIButton(type: .system)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        playButton.setTitle("CHALLENGE LEVEL \(level)", for: .normal)
        
        let trainingButton = UIButton(type: .system)
        trainingButton.addTarget(self, action: #selector(presentListViewController), for: .touchUpInside)
        trainingButton.setTitle("PRACTISE", for: .normal)

        [playButton, trainingButton].forEach { btn in
            btn.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(btn)
        }
    }
    
    @objc func playTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "sqns") as! SqnsViewController
        vc.games = items
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pract") as! PracticeViewController
        vc.games = items
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }

}
