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
    var originalText: String!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneEditing))
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
        
        originalText = notes[noteIndex].content
        noteTextView.text = notes[noteIndex].content
        
        // TODO: if view controller dismissed and note is empty, delete.
        
    }
    

    @objc func doneEditing() {
        // TODO: compare if text is the same there's no need to save / update notes
        if originalText == noteTextView.text {
            // TODO: just dismiss keyboard and editing
        } else {
            notes[noteIndex].content = noteTextView.text
            // FIXME: run on proper thread
            Defaults.save(notes: notes)
        }

        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func shareNote() {
        // FIXME: element to share is the note content (test with phone)
        let ac = UIActivityViewController(activityItems: ["hey, where my ppl at?"], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = shareButton
        present(ac, animated: true)
    }
}
