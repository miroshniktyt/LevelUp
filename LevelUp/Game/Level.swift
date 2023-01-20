//
//  Level.swift
//  game
//
//  Created by toha on 16.06.2021.
//

import Foundation

let planets = ["planetGreen", "planetYellow", "planetPurple"]
let allStars = ["starBlue", "starGreen", "starRed", "starPurple", "starYellow", "starOrange"]
let rockets = ["rocketOrange", "rocketPurple", "rocketGreen"]
var stars: [String] { Array(allStars[0...2]) }

var itemNames: [String] {
    let a = [1, 2, 3, 4, 5, 6, 7]
    let na = a.map { "item\($0)" }
    return na
}

let itemBG = "itemBG"
let itemBG2 = "frame"
let itemBGSelected = "itemBGSelected"

class Level {
    
    let key = "LEVEL"
    static let shared = Level()
    
    var level: Int {
        get {
            return UserDefaults.standard.integer(forKey: key)
        }
        set {
            guard newValue > 0 else {
                return
            }
            
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init() {
        UserDefaults.standard.register(defaults: [key : 1])
    }
}
