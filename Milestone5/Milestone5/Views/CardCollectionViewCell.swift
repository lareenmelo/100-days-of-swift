//
//  CardCollectionViewCell.swift
//  Milestone5
//
//  Created by Lareen Melo on 1/28/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var emoji: UILabel!
    
    func configure(_ card: Card) {
        emoji.text = card.emoji.rawValue
        
    }
}
