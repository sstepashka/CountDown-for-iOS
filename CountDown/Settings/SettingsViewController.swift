//
//  SettingsViewController.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 13/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    private var settings = Sounds.settings
    @IBOutlet var vibrateCell: VibrateSettingsCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vibrateCell.vibrate = settings.vibrate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        settings.vibrate = vibrateCell.vibrate
    }
    
    @IBAction func done(sender: Any) {
        self.dismiss(animated: true, completion: .none)
    }
}
