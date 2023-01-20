//
//  Base.swift
//  digger
//
//  Created by amure on 14.04.2021.
//

import UIKit

class BaseVC: UIViewController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}

class BaseNC: UINavigationController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}
