//
//  GameSettingsTableViewController.swift
//  Milestone5
//
//  Created by Lareen Melo on 2/1/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import UIKit

class GameSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Configuration") else {
            fatalError("Could not dequeue cell")
        }
        
        cell.textLabel?.text = "\(indexPath)"
        
        return cell
    }
}