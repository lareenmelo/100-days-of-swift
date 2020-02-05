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
    
    let userDefaults = UserDefaults.standard
    
    var pairs = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .done, target: self, action: #selector(newGame))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(showSettings))
        
        title = "Concentration Game"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        game = Concentration(with: pairs)
        cards = game.pairs
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pairs = userDefaults.integer(forKey: "pairs")
        game = Concentration(with: pairs)
        cards = game.pairs
        
        collectionView.reloadData()

    }
    
    @objc func newGame() {
        DispatchQueue.main.async { [weak self] in
            self?.game.newGame()
            self?.cards = (self?.game.pairs)!
            self?.collectionView.reloadData()
            
        }
    }
    
    @objc func showSettings() {
        let bundle = Bundle(for: ConcentrationGameViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let settingsViewController = storyboard.instantiateViewController(identifier: "settingsViewController") as? GameSettingsViewController else {
            fatalError()
        }
        
        navigationController?.pushViewController(settingsViewController, animated: true)
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

//GET OUT!!!!
extension ConcentrationGameViewController: UICollectionViewDelegateFlowLayout {
    // FIXME: Refactor me pls
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.bounds.size.height / CGFloat(6)
        
        let width = collectionView.bounds.size.height / CGFloat(3)
        
        
        return CGSize(width: width, height: height)
//
//        guard let navigationItemHeight = navigationController?.navigationBar.frame.height else {
//            return CGSize(width: 0.0, height: 0.0)
//        }
//        guard let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height else {
//            return CGSize(width: 0.0, height: 0.0)
//        }
//        let spacingBetweenCells = 8
//        let collectionWidth = collectionView.frame.size.width
//        let collectionHeight = collectionView.frame.size.height - (navigationItemHeight + statusBarHeight)
//        // FIXME: create a better size struct
//        let numberOfRows = CGFloat(4)
//        let numberOfColumns = CGFloat(3)
        
        
//        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
//         let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
//         return CGSize(width: itemWidth, height: itemWidth)
        
//        let cellHeight = (collectionHeight - (CGFloat(spacingBetweenCells) * numberOfRows)) /  CGFloat(numberOfRows.rounded(.down))
//        let cellWidth = (collectionWidth  - (CGFloat(spacingBetweenCells) * numberOfRows)) / CGFloat(numberOfColumns.rounded(.down))
//
//        return CGSize(width: cellWidth, height: cellHeight)
    }
}
