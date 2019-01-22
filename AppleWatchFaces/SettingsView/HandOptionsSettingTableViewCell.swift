//
//  HandOptionsSettingTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 12/9/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import UIKit

class HandOptionsSettingTableViewCell : WatchSettingsSelectableTableViewCell, UITextFieldDelegate {
    
    @IBOutlet var shouldShowHandOutlines:UISwitch!
    
    // called after a new setting should be selected ( IE a new design is loaded )
    override func chooseSetting( animated: Bool ) {
        guard let clockFaceSettings = SettingsViewController.currentClockSetting.clockFaceSettings else { return }
        shouldShowHandOutlines.isOn = clockFaceSettings.shouldShowHandOutlines
    }
    
    @IBAction func toggleSwitchButtonAction( sender: UIButton ) {
        shouldShowHandOutlines.isOn = !shouldShowHandOutlines.isOn
        self.switchValueDidChange(sender: shouldShowHandOutlines)
    }
    
    @IBAction func switchValueDidChange( sender: UISwitch ) {
        guard let clockFaceSettings = SettingsViewController.currentClockSetting.clockFaceSettings else { return }
        
        //add to undo stack for actions to be able to undo
        SettingsViewController.addToUndoStack()
        
        //update the value
        clockFaceSettings.shouldShowHandOutlines = sender.isOn
        
        NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:nil)
        NotificationCenter.default.post(name: WatchSettingsTableViewController.settingsTableSectionReloadNotificationName, object: nil,
                                        userInfo:["cellId": self.cellId , "settingType":"shouldShowHandOutlines"])
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
