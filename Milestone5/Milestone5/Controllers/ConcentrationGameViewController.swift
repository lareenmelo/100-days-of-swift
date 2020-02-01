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
    
    var cardsFacingUp = [CardCollectionViewCell]()
    var game: Concentration!
    
    
    
    var cards =  [Card]()
    let pairs = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: .done, target: self, action: #selector(newGame))
        
        title = "Magical Concentration Game"
        game = Concentration(with: 3)
        cards = game.pairs
        
    }
    
    @objc func newGame() {
        DispatchQueue.main.async { [weak self] in
            self?.game.newGame()
            self?.cards = (self?.game.pairs)!
            self?.collectionView.reloadData()
            
        }
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
        
        var status = cell.card.status
                
        if status == .facingDown {
            cell.flip()
            cardsFacingUp.append(cell)
            
            status = game.select(card: cell.card)
            cell.card.status = status

            if cardsFacingUp.count == 2 {
                if status == .matched {
                    cardsFacingUp[0].disable()
                    cardsFacingUp[0].card.status = .matched
                    cardsFacingUp[1].disable()
                    cardsFacingUp[1].card.status = .matched

                } else {
                    cardsFacingUp[0].flipBack()
                    cardsFacingUp[0].card.status = .facingDown
                    cardsFacingUp[1].flipBack()
                    cardsFacingUp[1].card.status = .facingDown

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
