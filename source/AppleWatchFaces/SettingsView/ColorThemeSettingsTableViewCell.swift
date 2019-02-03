//
//  ColorThemeSettingsTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 11/28/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ColorThemeSettingsTableViewCell: WatchSettingsSelectableTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var colorThemeSelectionCollectionView: UICollectionView!
    
    // called after a new setting should be selected ( IE a new design is loaded )
    override func chooseSetting( animated: Bool ) {
        //TODO: select the theme based on title?
    }
    
    func setCellSelection( indexPath: IndexPath ) {
        //select new one
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorTheme =  UserClockSetting.sharedColorThemeSettings[indexPath.row]
        debugPrint("selected color theme: " + colorTheme.title)
        
        //add to undo stack for actions to be able to undo
        SettingsViewController.addToUndoStack()
        
        //update the value
        SettingsViewController.currentClockSetting.applyColorTheme(colorTheme)
        SettingsViewController.currentClockSetting.themeTitle = colorTheme.title
        
        NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:nil)
        NotificationCenter.default.post(name: WatchSettingsTableViewController.settingsTableSectionReloadNotificationName, object: nil,
                                        userInfo:["cellId": self.cellId , "settingType":"colorTheme"])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserClockSetting.sharedColorThemeSettings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsColorThemeCell", for: indexPath) as! ColorThemeSettingCollectionViewCell
        
        let theme = UserClockSetting.sharedColorThemeSettings[indexPath.row]
        if let newImage = UIImage.getImageFor(imageName: theme.filename() ) {
            cell.thumbnail.image = newImage
        }
        cell.thumbnail.layer.cornerRadius = AppUISettings.cornerRadiusForSettingsThumbs
        cell.title.text = theme.title
        
        return cell
    }
    
    
}

