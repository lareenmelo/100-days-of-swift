//
//  Defaults.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/10/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import Foundation

struct Defaults {
    static let userDefaults = UserDefaults.standard
    static let userDefaultsKey = "notes"
    
    static func save(notes: [Note]) {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            userDefaults.set(savedData, forKey: userDefaultsKey)
        } else {
            print("Failed to save notes")
        }
        
    }
    
    static func load() -> [Note] {
        var notes = [Note]()
        
        if let savedNotes = userDefaults.object(forKey: userDefaultsKey) as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
                
            } catch {
                print("Failed to load notes.")
                
            }
        }

        return notes
    }
    
}
