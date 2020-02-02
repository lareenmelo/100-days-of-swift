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
    var status: Status
    var id: Int?
    
    init(with emoji: Emoji) {
        self.emoji = emoji
        status = Status.facingDown
    }
}
