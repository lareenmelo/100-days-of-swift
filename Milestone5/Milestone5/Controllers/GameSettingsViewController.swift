//
//  GameSettingsViewController.swift
//  Milestone5
//
//  Created by Lareen Melo on 2/2/20.
//  Copyright © 2020 Lareen Melo. All rights reserved.
//

import UIKit

class GameSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var settingsSections: UISegmentedControl!
    @IBOutlet var tableView: UITableView!

    let userDefaults = UserDefaults.standard
    let numberOfCards = [2, 3, 4, 6]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.delegate = self
        tableView.dataSource = self
        
        settingsSections.selectedSegmentIndex = 0
        settingsSections.setTitle("Layout", forSegmentAt: 0)
        settingsSections.setTitle("Themes", forSegmentAt: 1)
        
    }
    
    @IBAction func settingsSectionSelected(_ sender: Any) {
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if settingsSections.selectedSegmentIndex == 0 {
            return numberOfCards.count
        } else {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Configuration") else { fatalError() }
        
        if settingsSections.selectedSegmentIndex == 0 {
            cell.textLabel?.text = "\(numberOfCards[indexPath.row])"
        } else {
            cell.textLabel?.text = "\(indexPath)"

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settingsSections.selectedSegmentIndex == 0 {
            userDefaults.set(numberOfCards[indexPath.row], forKey: "pairs")
        }
    }
}
