//
//  VibrateSettingsCell.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 13/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import UIKit

@IBDesignable
class VibrateSettingsCell: UITableViewCell {
    private let vibrateSwitch = UISwitch()
    
    var vibrate: Bool {
        set (newValue){
            vibrateSwitch.setOn(newValue, animated: false)
        }
        
        get {
            return vibrateSwitch.isOn
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryView = vibrateSwitch
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
