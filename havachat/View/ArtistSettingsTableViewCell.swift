//
//  ArtistSettingsTableViewCell.swift
//  havachat
//
//  Created by Sean Wells on 5/2/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit

class ArtistSettingsTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor(red: 21/255, green: 25/255, blue: 101/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
       
       // MARK: - Init
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    // Mark: Selectors
    
    @objc func handleSwitchAction(sender: UISwitch) {
        if sender.isOn {
            print("Turned On")
        } else {
            print("Turned Off")
        }
    }

}
