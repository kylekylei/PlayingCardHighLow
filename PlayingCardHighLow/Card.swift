//
//  Card.swift
//  PlayingCardHighLow
//
//  Created by Kyle Lei on 2021/10/12.
//

import Foundation
import UIKit

enum Suit: Int, CaseIterable {
    case club = 1, diamond, heart, spades
    
    var emoji: String {
        switch self {
        case .club: return "♣"
        case .diamond: return "♦"
        case .heart: return "♥"
        case .spades: return"♠"
        }
    }
    
    var color: UIColor {
        switch self {
        case .club, .spades: return UIColor.black
        case .diamond, .heart: return UIColor.red
        }
    }
}

enum Rank: Int, CaseIterable {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    var emoji: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default: return String(self.rawValue)
        }
    }
}

struct Card {
    var suit: Suit
    var rank: Rank 
}

class Cards {
    var cardIndex: Int {
        return Suit.allCases.count * Rank.allCases.count - 1
    }
    
    var cards: [Card] {
        var cards = [Card]()
            for i in 1...Suit.allCases.count {
                for j in 1...Rank.allCases.count {
                    let card = Card(suit: Suit(rawValue: i)!, rank: Rank(rawValue: j)!)
                    cards.append(card)
                }
            }
            cards.shuffle()
        return cards
    }    
}
