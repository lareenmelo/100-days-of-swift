//
//  ViewController.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/7/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Notes]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Notes].self , from: savedNotes)
            } catch {
                print("Failed to load notes")
            }
            print(notes.count)
            tableView.reloadData()
        }
    }
    
    @objc func createNote() {
        let bundle = Bundle(for: ViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailVC.notes = notes
    
            navigationController?.pushViewController(detailVC, animated: true)
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
//        let bundle = Bundle(for: ViewController.self)
//        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//        if let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
//            detailVC.content = notes[indexPath.row].content
//
//            navigationController?.pushViewController(detailVC, animated: true)
//        }
    }
}

/*remember content is ? because at first, the app has no notes, so then
 you cannot just access the note's content. REMEMBER ITS DUMMY DATA, so
 if you create a note, direct them to the detail view controller, and save the content if dismissed.
 
 1. create a new note
 2. save note (even if dismissed like, go back)
 3. key board thingy
 4. instead of save, make it look like done
 5. do the custom thingy where the title is the first line and then the rest of the content is the second line (subtitle i think it was)
 */
