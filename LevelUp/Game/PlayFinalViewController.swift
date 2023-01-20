//
//  FinalViewController.swift
//  Buffalo Up
//
//  Created by toha on 23.03.2021.
//

import GameKit

class PlayFinalViewController: BaseVC {
    
    var isWinner = false
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isWinner {
            label.text = "GAME OVER"
            button.setTitle("PLAY AGGAIN", for: .normal)
            levelLabel.isHidden = true
        } else {
            label.text = "YOU WIN"
            button.setTitle("PLAY NEXT", for: .normal)
            levelLabel.isHidden = false
            Level.shared.level += 1
            let level = Level.shared.level
            levelLabel.text = "LEVEL \(level) IS OPEN NOW"
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if let gameVC = self.presentingViewController as? GameViewController {
            gameVC.setGame()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

class PracticeFinalViewController: BaseVC {
    
    var isWinner = false
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isWinner {
            label.text = "GAME OVER"
            button.setTitle("GO BACK", for: .normal)
        } else {
            label.text = "YOU WIN"
            button.setTitle("GO BACK", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if let gameVC = self.presentingViewController as? SqnsViewController {
            gameVC.setGame()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
