//
//  Card.swift
//  Milestone5
//
//  Created by Lareen Melo on 1/28/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import Foundation

struct Card {
    var emoji: Emoji
    //FIXME: state has to be a custom enum type
    var state: Bool
    
    init(with emoji: Emoji) {
        self.emoji = emoji
        state = false
    }
}
