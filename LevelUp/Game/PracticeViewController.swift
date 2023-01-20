//
//  ViewController.swift
//  LevelUp
//
//  Created by toha on 03.09.2021.
//

import UIKit
import SpriteKit

struct GameItem {
    let name: String
    let gameInfo: String
    let sceanType: SKScene.Type
}

class PracticeViewController: BaseVC {
    
    var games: [GameItem] = []

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
        
        var i = 0
        for gameItem in games {
            let button = UIButton(type: .system)
            button.tag = i
            button.addTarget(self, action: #selector(presentGameViewController(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(gameItem.name, for: .normal)
            stack.addArrangedSubview(button)
            i += 1
        }
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func presentGameViewController(_ sender: UIButton) {
        let item: GameItem = games[sender.tag]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "gameInit") as! GameViewController
        vc.game = item
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }


}

