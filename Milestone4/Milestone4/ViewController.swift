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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notes = Defaults.load()
        tableView.reloadData()

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
            // TODO: remove from user defaults
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
