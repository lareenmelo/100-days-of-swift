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
    var deleteNotesButton: UIBarButtonItem!
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
        
        // MARK: Toolbar Items Inits
        composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        // FIXME: hacer el force de una variable que cambie con el didSet, kkc.
        deleteNotesButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteNotes))

        // FIXME: notes aren't being updated.
        let totalNotes = UIBarButtonItem(title: "\(notes.count) Notes", style: .plain, target: self, action: nil)
        
        // TODO: init two arrays here.
        
        toolbarItems = [space, totalNotes, space, composeButton]
        navigationItem.rightBarButtonItem = editButton
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notes = Defaults.load()
        tableView.reloadData()

    }
    
    @IBAction func editingScene(_ sender: Any) {
        editScene.toggle()

        toolbarItems = [space, deleteNotesButton]
    }
    
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
    
    @objc func deleteNotes() {
        print("will do the magic to delete the notes")
    }
    
    // MARK: Table View Controller Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailViewController(noteIndex: indexPath.row)
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
