//
//  SecondHandSettingsTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 10/29/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class SecondHandSettingsTableViewCell: WatchSettingsSelectableTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var secondHandSelectionCollectionView: UICollectionView!
    
    //var selectedCellIndex:Int?
    
    // called after a new setting should be selected ( IE a new design is loaded )
    override func chooseSetting( animated: Bool ) {
        //debugPrint("** SecondHandSettingsTableViewCell called **")
    
        if let currentSecondHandType = SettingsViewController.currentClockSetting.clockFaceSettings?.secondHandType {
            if let secondHandTypeIndex = SecondHandTypes.userSelectableValues.firstIndex(of: currentSecondHandType) {
                let indexPath = IndexPath.init(row: secondHandTypeIndex, section: 0)
                
                //scroll and set native selection
                secondHandSelectionCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.right)
                
                //stupid hack to force selection after scroll
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                    self.setCellSelection(indexPath: indexPath)
                })
            }
        }
    }
    
    func setCellSelection( indexPath: IndexPath ) {
        //select new one
        if let settingsHandCell = secondHandSelectionCollectionView.cellForItem(at: indexPath) as? SecondHandSettingCollectionViewCell {
            if let scene = settingsHandCell.skView.scene, let selectedNode = scene.childNode(withName: "selectedNode") {
                //TODO: animate this
                selectedNode.isHidden = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondHandType = SecondHandTypes.userSelectableValues[indexPath.row]
        debugPrint("selected cell secondHandType: " + secondHandType.rawValue)
        
        //add to undo stack for actions to be able to undo
        SettingsViewController.addToUndoStack()
        
        //update the value
        SettingsViewController.currentClockSetting.clockFaceSettings?.secondHandType = secondHandType
        NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:nil) //userInfo:["data": 42, "isImportant": true]
        NotificationCenter.default.post(name: WatchSettingsTableViewController.settingsTableSectionReloadNotificationName, object: nil,
                                        userInfo:["cellId": self.cellId , "settingType":"secondHandType"])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let secondHandType = SecondHandTypes.userSelectableValues[indexPath.row]
        debugPrint("deSelected cell secondHandType: " + secondHandType.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return SecondHandTypes.userSelectableValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsHandCell", for: indexPath) as! SecondHandSettingCollectionViewCell
    
        if cell.skView.scene == nil  {
            //first run. create a new scene
            let previewScene = SKScene.init()
            previewScene.scaleMode = .aspectFill
            
            // Present the scene
            cell.skView.presentScene(previewScene)
        }
        
        if let scene = cell.skView.scene {
            //debugPrint("old scene")
            scene.removeAllChildren()
            
            cell.secondHandType = SecondHandTypes.userSelectableValues[indexPath.row]
            
            let scaleMultiplier:CGFloat = 0.008
            
            let handNode = SecondHandNode.init(secondHandType: SecondHandTypes.userSelectableValues[indexPath.row])
            handNode.setScale(scaleMultiplier)
            handNode.position = CGPoint.init(x: scene.size.width/2, y: scene.size.width/7)
            scene.addChild(handNode)
            
            let highlightColor = SKColor.init(hexString: AppUISettings.settingHighlightColor)
            let highlightLineWidth = AppUISettings.settingLineWidthBeforeScale * 1.3
            let selectedHandNode = SecondHandNode.init(secondHandType: SecondHandTypes.userSelectableValues[indexPath.row], material: "#ff0000ff", strokeColor: highlightColor, lineWidth:highlightLineWidth)
            selectedHandNode.name = "selectedNode"
            selectedHandNode.setScale(scaleMultiplier)
            selectedHandNode.position = CGPoint.init(x: scene.size.width/2, y: scene.size.width/7)
            
            selectedHandNode.isHidden = !cell.isSelected

            scene.addChild(selectedHandNode)
        }
        
        return cell
    }
    
    
}
