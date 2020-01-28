//
//  ViewController.swift
//  Milestone5
//
//  Created by Lareen Melo on 1/24/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    let emojis = ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "☺️", "😊", "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "☺️", "😊"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCollectionViewCell else { fatalError("Could not dequeue cell") }
        
        cell.emoji.text = emojis[indexPath.row]
        
        return cell
    }
}
