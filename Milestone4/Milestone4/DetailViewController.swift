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
                
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
        // TODO: if view controller dismissed and note is empty, delete.

    }

    @objc func doneEditing() {
        if originalText != noteTextView.text {
            notes[noteIndex].content = noteTextView.text
            saveNote()
        }

        navigationController?.popViewController(animated: true)
        
    }
    
    func saveNote() {
        // TODO: add priority
        DispatchQueue.global().async { [weak self] in
            if let notes = self?.notes {
                Defaults.save(notes: notes)

            }
        }
    }
    
    @objc func shareNote() {
        // FIXME: element to share is the note content (test with phone)
        let ac = UIActivityViewController(activityItems: ["hey, where my ppl at?"], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = shareButton
        present(ac, animated: true)
    }
}
