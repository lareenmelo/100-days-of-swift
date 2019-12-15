//
//  ViewController.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/7/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes: [Note] {
        get {
        return Defaults.load()
        }
        set {
            Defaults.save(notes: newValue)
        }
    }
    
    let userDefaults = UserDefaults.standard
    
    // MARK: Navigation Items Declaration
    @IBOutlet var editButton: UIBarButtonItem!
    
    // MARK: Toolbar Items Declaration
    var composeButton: UIBarButtonItem!
    var totalNotes: UIBarButtonItem!
    var deleteAllNotesButton: UIBarButtonItem!
    var deleteSelectedNotesButton: UIBarButtonItem!
    // Empty button to replicate notes layout
    var space: UIBarButtonItem!

    // Toggles editButton title so it goes along with the correct actions.
    var editScene: Bool = false {
        didSet {
            if editScene {
                editButton.title = "Cancel"
            } else {
                editButton.title = "Edit"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.title = "Edit"
        tableView.allowsMultipleSelectionDuringEditing = true
        
        // MARK: Toolbar Items Inits
        composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        deleteAllNotesButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllNotes))
        deleteSelectedNotesButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteNotes))
        // FIXME: notes aren't being updated.
        totalNotes = UIBarButtonItem(title: "\(notes.count) Notes", style: .plain, target: self, action: nil)
        
        // TODO: init two arrays here.
        toolbarItems = [space, totalNotes, space, composeButton]
        navigationItem.rightBarButtonItem = editButton
        navigationController?.isToolbarHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        notes.sort(by: { $0.creationDate >= $1.creationDate })
        tableView.reloadData()
        totalNotes.title = "\(notes.count) Notes"

    }
    
    // MARK: Editing Scene
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    @IBAction func editingScene(_ sender: Any) {
        guard let title = (sender as! UIBarButtonItem).title else { return }

        switch(title) {
        case "Edit":
            toolbarItems = [space, deleteAllNotesButton]

        case "Cancel":
            toolbarItems = [space, totalNotes, space, composeButton]

        default:
            print("The edit button's title didn't match with the cases of the @editingScene function.")
            break
        }
                
        editScene.toggle()
        setEditing(editScene, animated: true)

    }
    
    func quitEditingScene() {
        setEditing(false, animated: true)
        editScene.toggle()
        toolbarItems = [space, totalNotes, space, composeButton]
        
    }
    
    // MARK: Note Handlers
    @objc func createNote() {
        let newNote = Note(content: "", creationDate: Date())
        save(note: newNote)
        
        openDetailViewController(selectedNote: newNote, noteIndex: notes.count - 1)
    }
    
    @objc func deleteAllNotes() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteAll()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(destroyAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    @objc func deleteNotes() {
        let alert = UIAlertController(title: "Delete Notes", message: "Are you sure you want to delete these notes? Once deleted you won't be able to see them again.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteSelected()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func deleteAll() {
        notes.removeAll()
        totalNotes.title = "\(notes.count) Notes"
        tableView.reloadData()

        quitEditingScene()
    }
    
    func deleteSelected() {
        // FIXME: find more elegant solution to the index order issues
        guard let selectedIndexes = tableView.indexPathsForSelectedRows else { return }
        var rows = selectedIndexes
        rows.sort(by: >)
        
        for index in rows {
            notes.remove(at: index.row)
        }

        totalNotes.title = "\(notes.count) Notes"
        tableView.reloadData()
        quitEditingScene()
    }
    
    // MARK: Table View Controller Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        
        if let cell = cell as? NoteCell {
            cell.noteDescription.text = "testing it now LOL"
            cell.noteTitle.text = notes[indexPath.row].content
            cell.creationDate.text = formatDate(notes[indexPath.row].creationDate)
        }
        
        return cell
    }
    
    // MARK: Cell Interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            toolbarItems = [space, deleteSelectedNotesButton]

        } else {
            openDetailViewController(selectedNote: notes[indexPath.row], noteIndex: indexPath.row)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if tableView.indexPathsForSelectedRows == nil || tableView.indexPathsForSelectedRows!.isEmpty {
                toolbarItems = [space, deleteAllNotesButton]

            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath.row)
            totalNotes.title = "\(notes.count) Notes"
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }

    
    func openDetailViewController(selectedNote: Note, noteIndex: Int) {
        let bundle = Bundle(for: ViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailVC.notesStorageDelegate = self
            detailVC.selectedNote = selectedNote
            detailVC.noteIndex = noteIndex
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        let weekDateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        
        guard let week = calendar.date(from: weekDateComponents) else {return "Failed to find Week @formatDate"}

        guard let sunday = calendar.date(byAdding: .day, value: 7, to: week) else { return "Failed to find end of week @formatDate" }
        guard let monday = calendar.date(byAdding: .day, value: 1, to: week) else { return "Failed to find start of week @formatDate" }

        if date <= sunday && date >= monday {

            if calendar.isDateInToday(date) {
                formatter.timeStyle = .short
                
            } else if calendar.isDateInYesterday(date) {
                return "Yesterday"
                
            } else {
                formatter.dateFormat = "EEEE"
            }
            
        } else {
            formatter.dateStyle = .short
        }

        return formatter.string(from: date)
    }
}

extension ViewController: NoteStorageDelegate {
    func save(note: Note) {
        notes.append(note)
    }
    
    func update(note: Note, at index: Int) {
        notes[index] = note
    }
    
    func deleteNote(at index: Int) {
        notes.remove(at: index)
    }
    
    func note(at index: Int) -> Note {
        return notes[index]
        
    }

}
