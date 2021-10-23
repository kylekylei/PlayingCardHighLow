//
//  Game.swift
//  PlayingCardHighLow
//
//  Created by Kyle Lei on 2021/10/14.
//

import Foundation
import UIKit

class Player {
    var cardCombol = Card(suit: .club, rank: .ace)
    var score = 0
    
    func compare(against oppositePlayer: Player) {
        if self.cardCombol.rank.rawValue > oppositePlayer.cardCombol.rank.rawValue {
            self.score += 100
            
        }else if self.cardCombol.rank.rawValue  == oppositePlayer.cardCombol.rank.rawValue {
            if self.cardCombol.suit.rawValue > oppositePlayer.cardCombol.suit.rawValue {
                self.score += 100
            }else{
                oppositePlayer.score += 100
            }
        }else {
            oppositePlayer.score += 100
        }
    }
}

class RightPlayer: Player {
}

class LeftPlayer: Player {
}

enum PlayerDirection: String {
    case right
    case left
}

enum DrawOrder: Int {
    case firstDraw = 0
    case secondDraw    
}
