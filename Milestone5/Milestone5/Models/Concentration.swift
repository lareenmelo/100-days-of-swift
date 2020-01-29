//
//  Concentration.swift
//  Milestone5
//
//  Created by Lareen Melo on 1/28/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import Foundation

class Concentration {
    // FIXME: set emoji theme.
    var pairs = [Card]()
    // FIXME: limit the number of pairs to UI space
    // && number of emoji cases (unless we'd like to apply a different logic to that.
    func shuffle(_ numberOfPairs: Int) -> [Card] {
        var emojis = Emoji.allCases
        var card: Card
        
        for _ in 1...numberOfPairs {
            let randomEmojiIndex = Int.random(in: 0..<emojis.count)
            
            let emoji = emojis[randomEmojiIndex]
            card = Card(with: emoji)
            pairs += [card, card]
            
            emojis.remove(at: randomEmojiIndex)
        }
        
        return pairs.shuffled()
        
    }
}
