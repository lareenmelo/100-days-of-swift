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
        contentView.layer.cornerRadius = 16.0
        contentView.clipsToBounds = true
        contentView.isHidden = false
        
        cardImage.image = UIImage(named: "card_back")
        
        self.card = card
        emoji.text = card.emoji.rawValue
        emoji.isHidden = true
        
    }
    
    func flip() {
        UIView.transition(from: cardImage, to: emoji, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        emoji.isHidden = false
        
        
    }
    
    func flipBack() {
        let pause = DispatchTime.now() + .milliseconds(700)
        
        DispatchQueue.main.asyncAfter(deadline: pause) { [weak self] in
            UIView.transition(from: self!.emoji, to: self!.cardImage, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            self?.emoji.isHidden = true
            
        }
    }
    
    func disable() {
        let pause = DispatchTime.now() + .milliseconds(700)
        
        DispatchQueue.main.asyncAfter(deadline: pause) { [weak self] in
            self?.contentView.isHidden = true
        }
    }
}
