//
//  DetailViewController.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/7/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    @IBOutlet var noteTextView: UITextView!
    var notes = [Note]()
    var noteIndex: Int!
    var shareButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
        
        noteTextView.text = notes[noteIndex].content
        
    }
    

    @objc func save() {
        let newNote = Note(id: UUID().uuidString, content: noteTextView.text)
        notes.append(newNote)
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            userDefaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save notes")
        }
            
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func shareNote() {
        // share selected note
        let ac = UIActivityViewController(activityItems: ["hey, where my ppl at?"], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = shareButton
        present(ac, animated: true)
    }
}
