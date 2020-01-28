//
//  Concentration.swift
//  Milestone5
//
//  Created by Lareen Melo on 1/28/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import Foundation

class Concentration {
    var pairs = [Card]()
    
    func shuffle() -> [Card] {
        let emojis = Emoji.allCases
        
        var card: Card
        for emoji in emojis {
            card = Card(with: emoji)
            pairs += [card, card]
        }
        
        return pairs.shuffled()
        
    }
}
