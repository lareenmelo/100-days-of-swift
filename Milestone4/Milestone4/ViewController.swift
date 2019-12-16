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

        guard let background = UIImage(named: "white_background") else { return }

        // MARK: Navigation Controller Styling
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(background, for: .default)
        navigationController?.navigationBar.setBackgroundImage(background, for: .defaultPrompt)
        navigationController?.navigationBar.setBackgroundImage(background, for: .compact)
        navigationController?.navigationBar.setBackgroundImage(background, for: .compactPrompt)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // MARK: Tableview properties
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.backgroundColor = UIColor(patternImage: background)
        tableView.tableFooterView = UIView()
        
        // MARK: Toolbar styling
        navigationController?.toolbar.setBackgroundImage(UIImage(named: "white_background"), forToolbarPosition: .any, barMetrics: .default)
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        navigationController?.toolbar.backgroundColor = UIColor.clear
        
        // MARK: Toolbar Items Inits
        composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        deleteAllNotesButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllNotes))
        deleteSelectedNotesButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteNotes))
        
        // FIXME: remove high light when clicked
        let notesCount = notes.count > 0 ? "\(notes.count)" : "No"
            totalNotes = UIBarButtonItem(title: "\(notesCount) Notes", style: .plain, target: self, action: nil)

        totalNotes.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.foregroundColor : UIColor.darkText
            ], for: .normal)
        
        setTootlbarItemsColor()
        
        // TODO: init two arrays here.
        toolbarItems = [space, totalNotes, space, composeButton]
        navigationItem.rightBarButtonItem = editButton
        navigationController?.isToolbarHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        notes.sort(by: { $0.creationDate >= $1.creationDate })
        tableView.reloadData()
        let notesCount = notes.count > 0 ? "\(notes.count)" : "No"

        totalNotes.title = "\(notesCount) Notes"

    }
    
    func setTootlbarItemsColor() {
        let orangeColor = #colorLiteral(red: 0.9803921569, green: 0.7254901961, blue: 0.1725490196, alpha: 1)
        composeButton.tintColor = orangeColor
        deleteAllNotesButton.tintColor = orangeColor
        deleteSelectedNotesButton.tintColor = orangeColor

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
        
        alert.view.tintColor = #colorLiteral(red: 0.9803921569, green: 0.7254901961, blue: 0.1725490196, alpha: 1)
        
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
        
        alert.view.tintColor = #colorLiteral(red: 0.9803921569, green: 0.7254901961, blue: 0.1725490196, alpha: 1)

        present(alert, animated: true)
        
    }
    
    func deleteAll() {
        notes.removeAll()
        let notesCount = notes.count > 0 ? "\(notes.count)" : "No"

        totalNotes.title = "\(notesCount) Notes"
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

        let notesCount = notes.count > 0 ? "\(notes.count)" : "No"

        totalNotes.title = "\(notesCount) Notes"
        tableView.reloadData()
        quitEditingScene()
    }
    
    // MARK: Table View Controller Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        
        let note = notes[indexPath.row]
        let noteSplit = note.content.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: true)
                
        if let cell = cell as? NoteCell {
            cell.noteDescription.text = splitSubtitle(noteSplit)
            cell.noteTitle.text = splitTitle(noteSplit)
            cell.creationDate.text = formatDate(note.creationDate)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7254901961, blue: 0.1725490196, alpha: 1).withAlphaComponent(0.2)
        cell.selectedBackgroundView = backgroundView
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
            let notesCount = notes.count > 0 ? "\(notes.count)" : "No"

            totalNotes.title = "\(notesCount) Notes"
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
        let daysSet: Set<Calendar.Component> = [.day]
        guard let days = calendar.dateComponents(daysSet, from: Date(), to: date).day else { return "Couldn't calculate days @formatDate." }
        
        if days <= 7 {
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
    

    func splitTitle(_ split: [Substring]) -> String {
        if split.count >= 1 {
            return String(split[0])
        }
        return "New Note"
        
    }
    
    func splitSubtitle(_ split: [Substring]) -> String {
        if split.count >= 2 {
            return String(split[1])
        }
        return "No additional text"
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
