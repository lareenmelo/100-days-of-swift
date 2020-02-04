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
//        guard let sender = sender as? UISegmentedControl else { return }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if settingsSections.selectedSegmentIndex == 0 {
            return 5
        } else {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Configuration") else { fatalError() }
        
        cell.textLabel?.text = "\(indexPath)"
        
        return cell
    }
}
