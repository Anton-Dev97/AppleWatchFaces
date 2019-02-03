//
//  ColorSettingsTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 11/7/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import UIKit
import SpriteKit

class ColorSettingsTableViewCell: WatchSettingsSelectableTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public var colorList : [String] = []
    var sizedCameraImage : UIImage?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadColorList()
    }
    
    func colorListVersion( unfilteredColor: String ) -> String {
        //debugPrint("unnfiltered:" + unfilteredColor)
        //TODO: add #
        let colorListVersion = unfilteredColor.lowercased()
        //keep only first 6 chars
        let colorListVersionSubString = String(colorListVersion.prefix(9))
        
        //should be
        //#d8fff8ff
        
        //debugPrint("filtered:" + colorListVersionSubString)
        
        return colorListVersionSubString
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsColorCell", for: indexPath) as! ColorSettingCollectionViewCell
                
        if AppUISettings.materialIsColor(materialName: colorList[indexPath.row] ) {
            cell.circleView.backgroundColor = SKColor.init(hexString: colorList[indexPath.row] )
        } else {
            if let image = UIImage.init(named: colorList[indexPath.row] ) {
                cell.circleView.backgroundColor = SKColor.init(patternImage: image)
            }
        }
        
        return cell
    }
    
    // MARK: - Utility functions
    
    // load colors from Colors.plist and save to colorList array.
    private func loadColorList() {
        // create path for Colors.plist resource file.
        let colorFilePath = Bundle.main.path(forResource: "Colors", ofType: "plist")
        
        // save piist file array content to NSArray object
        let colorNSArray = NSArray(contentsOfFile: colorFilePath!)
        
        // Cast NSArray to string array.
        colorList = colorNSArray as! [String]
        
        //add in the materials
        colorList.insert(contentsOf: AppUISettings.materialFiles, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let cameraImage = UIImage.init(named: "cameraIcon") {
            sizedCameraImage = AppUISettings.imageWithImage(image: cameraImage, scaledToSize: CGSize.init(width: 27, height: 27))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
