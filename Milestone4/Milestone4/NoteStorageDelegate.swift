//
//  NoteStorageDelegate.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/13/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import Foundation


protocol NoteStorageDelegate {
    var notes: [Note] { get }
    
    func save(note: Note)
    func update(note: Note, at index: Int)
}
