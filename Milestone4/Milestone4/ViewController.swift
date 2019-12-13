//
//  ViewController.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/7/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()
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
        notes = Defaults.load()
        tableView.reloadData()

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
    
    // MARK: Note Handlers
    @objc func createNote() {
        let newNote = Note(content: "")
        notes.append(newNote)
        
        // TODO: add priority
        DispatchQueue.global().async { [weak self] in
            if let notes = self?.notes {
                Defaults.save(notes: notes)
                
                DispatchQueue.main.async {
                    self?.openDetailViewController(noteIndex: notes.count - 1)
                    
                }
            }
        }
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
        print("deleteNotes")
        print(tableView.indexPathsForSelectedRows)
        
    }
    
    func deleteAll() {
        notes.removeAll()
        
        DispatchQueue.global().async { [weak self] in
            if let notes = self?.notes {
                Defaults.save(notes: notes)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        
        setEditing(false, animated: true)
        editScene.toggle()
        toolbarItems = [space, totalNotes, space, composeButton]

    }
    
    // MARK: Table View Controller Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        
        if let cell = cell as? NoteCell {
            cell.noteDescription.text = ""
            cell.noteTitle.text = notes[indexPath.row].content
        }
        
        return cell
    }
    
    // MARK: Cell Interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            toolbarItems = [space, deleteSelectedNotesButton]

        } else {
            openDetailViewController(noteIndex: indexPath.row)
            
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
            notes.remove(at: indexPath.row)

            DispatchQueue.global().async { [weak self] in
                if let notes = self?.notes {
                    Defaults.save(notes: notes)
                    
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)

                    }
                }
            }
        }
    }
    
    func openDetailViewController(noteIndex: Int) {
        let bundle = Bundle(for: ViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailVC.notes = notes
            detailVC.noteIndex = noteIndex
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
