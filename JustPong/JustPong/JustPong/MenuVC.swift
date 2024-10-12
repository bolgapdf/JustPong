//
//  MenuVC.swift
//  JustPong
//
//  Created by Jacob Silva on 10/10/24.
//

import Foundation
import UIKit

enum difficulty {
    case easy
    case medium
    case hard
}

class MenuVC : UIViewController {
    
    
    
    
    @IBAction func easy(_ sender: Any) {
        moveToGame(game: .easy)
    }
    
    @IBAction func medium(_ sender: Any) {
        moveToGame(game: .medium)
    }
    
    @IBAction func hard(_ sender: Any) {
        moveToGame(game: .hard)
    }
    
    func moveToGame(game : difficulty){
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentDifficulty = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
}
