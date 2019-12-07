//
//  ViewController.swift
//  Milestone4
//
//  Created by Lareen Melo on 12/7/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let notes = [(id: "Note#1", content: "WHERE"), (id: "Note#2", content: "MY"), (id: "Note#3", content: "PPL"), (id: "Note#4", content: "AT")]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].id
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bundle = Bundle(for: ViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailVC.content = notes[indexPath.row].content
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

