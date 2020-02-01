//
//  ConcentrationGameViewController.swift
//  Milestone5
//
//  Created by Lareen Melo on 1/28/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import UIKit

class ConcentrationGameViewController: UICollectionViewController {
    
    @IBOutlet var cardBackImage: UIImageView!
    var cards =  [Card]()
    let pairs = 3
    var cardsFacingUp = [CardCollectionViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let game = Concentration(with: 4)
        cards = game.pairs
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCollectionViewCell else { fatalError("Could not dequeue cell") }
        
        let card = cards[indexPath.row]
        cell.configure(card)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        
        if cell.card.state == false {
            cell.flip()
            cardsFacingUp.append(cell)
            
            if cardsFacingUp.count == 2 {
                if cardsFacingUp[0].emoji.text != cardsFacingUp[1].emoji.text {
                    for card in self.cardsFacingUp {
                        card.flipBack()
                    }
                    
                } else {
                    // FIXME: disable simultaneously
                    cardsFacingUp[0].disable()
                    cardsFacingUp[1].disable()
                }
                
                cardsFacingUp = [CardCollectionViewCell]()
            }
        }
    }
}

extension ConcentrationGameViewController: UICollectionViewDelegateFlowLayout {
    // FIXME: Refactor me pls
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let navigationItemHeight = navigationController?.navigationBar.frame.height else {
            return CGSize(width: 0.0, height: 0.0)
        }
        guard let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height else {
            return CGSize(width: 0.0, height: 0.0)
        }
        let spacingBetweenCells = 16
        let collectionWidth = collectionView.frame.size.width
        let collectionHeight = collectionView.frame.size.height - (navigationItemHeight + statusBarHeight)
        // FIXME: create a better size struct
        let numberOfRows = CGFloat(3)
        let numberOfColumns = CGFloat(2)
        
        let cellHeight = (collectionHeight - (CGFloat(spacingBetweenCells) * numberOfRows)) / numberOfRows
        let cellWidth = (collectionWidth - (CGFloat(spacingBetweenCells) * numberOfColumns)) / numberOfColumns
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
