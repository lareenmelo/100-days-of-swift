//
//  DetailViewController.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/7/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    let userDefaults = UserDefaults.standard
    @IBOutlet var noteTextView: UITextView!
    
    var selectedNote: Note!
    var noteIndex: Int!
    var shareButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    var originalText: String!
    var noteIsEmpty: Bool!
    
    // delegate
    var notesStorageDelegate: NoteStorageDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneEditing))
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
        
        originalText = selectedNote.content
        noteTextView.text = selectedNote.content
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: add validations as to when to save the notes
        
        if noteTextView.text == "" {
            notesStorageDelegate.deleteNote(at: noteIndex)
        } else {
            selectedNote.content = noteTextView.text
            notesStorageDelegate.update(note: selectedNote, at: noteIndex)
        }
    }

    
    @objc func doneEditing() {
        if originalText != noteTextView.text {
            selectedNote.content = noteTextView.text
            saveNote()
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func saveNote() {
        notesStorageDelegate.update(note: selectedNote, at: noteIndex)
        
    }
    
    @objc func shareNote() {
        // FIXME: element to share is the note content (test with phone)
        let ac = UIActivityViewController(activityItems: ["hey, where my ppl at?"], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = shareButton
        present(ac, animated: true)
    }
}
