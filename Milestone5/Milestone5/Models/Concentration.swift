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
    var pairs: [Card]!
    var numberOfPairs: Int
    private var selectedCards = [Card]()

    init(with numberOfPairs: Int) {
        self.numberOfPairs = numberOfPairs
        self.shuffle(numberOfPairs)
        
    }
    
    private func match(_ first: Card, _ second: Card) -> Bool {
        return first.emoji.rawValue == second.emoji.rawValue
        
    }
    
    func select(card: Card) -> Status {
        var status = card.status
        
        if status == .facingDown {
            status = .facingUp
            selectedCards.append(card)
            
            if selectedCards.count == 2 {
                let firstCard = selectedCards[0]
                let secondCard = selectedCards[1]
                
                if match(firstCard, secondCard) {
                    status = .matched

                } else {
                    status = .facingDown
                    
                }
                
                selectedCards = [Card]()

            }
        }

        
        return status
        
    }
    
    func newGame() {
        shuffle(numberOfPairs)
        // change all cards status to facing downnnnn
    }
    
    // FIXME: number of emoji cases (unless we'd like to apply a different logic to that.
    func shuffle(_ numberOfPairs: Int) {
        var emojis = Emoji.allCases
        var card: Card
        var cards = [Card]()
        
        for _ in 1...numberOfPairs {
            let randomEmojiIndex = Int.random(in: 0..<emojis.count)
            
            let emoji = emojis[randomEmojiIndex]
            card = Card(with: emoji)
            cards += [card, card]
            
            emojis.remove(at: randomEmojiIndex)
        }
        
        pairs = cards.shuffled()
    }
}
