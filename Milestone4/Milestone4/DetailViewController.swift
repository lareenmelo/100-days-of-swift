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
    var createNote: UIBarButtonItem!
    var space: UIBarButtonItem!
    var deleteNote: UIBarButtonItem!
    var originalText: String!
    var noteIsEmpty: Bool!
    
    // delegate
    var notesStorageDelegate: NoteStorageDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneEditing))
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        createNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
        deleteNote = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteCurrentNote))
        space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
        
        toolbarItems = [deleteNote, space, createNote]
        navigationController?.isToolbarHidden = false
        
        originalText = selectedNote.content
        noteTextView.text = selectedNote.content
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: add validations as to when to save the notes
        guard noteIndex != nil else { return }
        if noteTextView.text == "" {
            notesStorageDelegate.deleteNote(at: noteIndex)
        } else {
            selectedNote.creationDate = Date()
            selectedNote.content = noteTextView.text
            notesStorageDelegate.update(note: selectedNote, at: noteIndex)
        }
    }

    
    @objc func doneEditing() {
        if originalText != noteTextView.text {
            selectedNote.creationDate = Date()
            selectedNote.content = noteTextView.text
            saveNote()
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func saveNote() {
        notesStorageDelegate.update(note: selectedNote, at: noteIndex)
        
    }
    
    @objc func createNewNote() {
        selectedNote.creationDate = Date()
        selectedNote.content = noteTextView.text
        saveNote()
        
        let newNote = Note(content: "", creationDate: Date())
        notesStorageDelegate.save(note: newNote)
        
        noteIndex = notesStorageDelegate.notes.count - 1
        originalText = ""
        noteTextView.text = ""
        
        saveNote()

    }
    
    @objc func deleteCurrentNote() {
        notesStorageDelegate.deleteNote(at: noteIndex)

        let notes = notesStorageDelegate.notes.count
        
        if noteIndex < notes {
            selectedNote = notesStorageDelegate.note(at: noteIndex)
            noteTextView.text = selectedNote.content
            return

        } else if notes > 0 {
            noteIndex = notes - 1
            selectedNote = notesStorageDelegate.note(at: noteIndex)
            noteTextView.text = selectedNote.content
            return
            
        }
        
        noteIndex = nil
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func shareNote() {
        selectedNote.creationDate = Date()
        selectedNote.content = noteTextView.text
        notesStorageDelegate.update(note: selectedNote, at: noteIndex)
        
        let ac = UIActivityViewController(activityItems: [selectedNote.content], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = shareButton
        present(ac, animated: true)
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        
        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
    }
    
}
