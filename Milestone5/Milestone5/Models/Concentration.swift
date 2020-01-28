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
    
    // shuffle with # of pairs
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
