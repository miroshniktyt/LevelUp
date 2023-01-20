//
//  Scene.swift
//  LevelUp
//
//  Created by 1 on 30.01.2022.
//

import SpriteKit

class Scene: SKScene {
    weak var gameOverDelegate: GameOverable?
    var level = 0
    
    deinit {
        print("deinited")
    }
}
