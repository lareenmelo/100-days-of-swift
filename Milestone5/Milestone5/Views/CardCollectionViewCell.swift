//
//  CardCollectionViewCell.swift
//  Milestone5
//
//  Created by Lareen Melo on 1/28/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cardImage: UIImageView!
    @IBOutlet var emoji: UILabel!
    var card: Card!
    
    func configure(_ card: Card) {
        cardImage.image = UIImage(named: "card_back")
        
        self.card = card
        emoji.text = card.emoji.rawValue
        emoji.isHidden = true
        
    }
    
    func flip() {
        UIView.transition(from: cardImage, to: emoji, duration: 0.5, options: .transitionFlipFromLeft, completion: nil)
        emoji.isHidden = false
        
        card.state.toggle()
        
    }
    
    func flipBack() {
        
        UIView.transition(from: emoji, to: cardImage, duration: 0.5, options: .transitionFlipFromLeft, completion: nil)
        emoji.isHidden = true

        card.state.toggle()

    }
}
