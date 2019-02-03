//
//  AppUISettings.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 11/11/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import Foundation

import SpriteKit

class AppUISettings: NSObject {
    
    /*
    These are "theme" settings for the app overall.  Items go here that will be set ( or overriden ) in code that will affect the look and feel of the app.
    Eventually, we might want to load this from JSON or a plist ? */
    
    //turn this of override in code to turn the button on to re-render the thumbnails into the docs folder using the simulator
    // only need to do this if you make changes to the themes.json file and need fresh icons
    static let showRenderThumbsButton = true
 
    //the color used when highlighting the cell items
    static let settingHighlightColor:String = "#38ff9b"

    //line width for settings SKNodes strokes ( before scaling )
    static let settingLineWidthBeforeScale:CGFloat = 3.0
    
    //corner radius for thumbnails in settings
    static let cornerRadiusForSettingsThumbs:CGFloat = 16.0
    
    //corner and border settings for "watch frame"
    static let watchFrameCornerRadius:CGFloat = 28.0
    static let watchFrameBorderWidth:CGFloat = 4.0
    static let watchFrameBorderColor = SKColor.darkGray.cgColor

    static let materialFiles = [
        "80sTubes.jpg","AppleDigital.jpg","BackToTheFuture.jpg","Beeker.jpg","BlueSky.jpg","Calculator.jpg","gameBoy.jpg",
        "GreyDots.jpg","HangingLight.jpg","MelloYello.jpg","OpticalIllusion.jpg","PixelSquares.jpg","RainbowLines.jpg","Squigglies.jpg",
        "80sDigital.jpg", "brass.jpg","brushedsteel.jpg","light-wood.jpg", "vinylAlbum.jpg", "wallpaper70s.jpg", "watchGears.jpg", "copper.jpg"]
    
    static func materialIsColor( materialName: String ) -> Bool {
        if (materialName.lengthOfBytes(using: String.Encoding.utf8) > 0) {
            let index = materialName.index(materialName.startIndex, offsetBy: 1)
            let firstChar = materialName[..<index]  //materialName.substring(to: index)
            
            if ( firstChar == "#") {
                return true
            }
        }
        
        return false
    }
    
    //time settings used when generating thumbnail screen shots
    //  ( focuses goods in upper-right )
    static let screenShotSeconds:CGFloat = 25
    static let screenShotHour:CGFloat = 9
    static let screenShotMinutes:CGFloat = 41

    //ring text slider
    static let ringSettigsSliderTextMin:Float = 0
    static let ringSettigsSliderTextMax:Float = 1.5

    //ring shape sliders
    static let ringSettigsSliderShapeMin:Float = 0
    static let ringSettigsSliderShapeMax:Float = 1.5
    
    //ring spacer slider
    static let ringSettigsSliderSpacerMin:Float = 0
    static let ringSettigsSliderSpacerMax:Float = 1.5
    
    //some other DRY settings
    static let thumbnailFolder = "thumbs"
    static let backgroundFileName = "-customBackground"
    
    static func deleteAllFolders() {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        let newDir = docsURL.appendingPathComponent(AppUISettings.thumbnailFolder)
        
        do{
            try filemgr.removeItem(at: newDir)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    static func createFolders() {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        let newDir = docsURL.appendingPathComponent(AppUISettings.thumbnailFolder).path
        
        do{
            try filemgr.createDirectory(atPath: newDir,withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    static func copyFolders() {
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        
        let folderPath = Bundle.main.resourceURL!.path
        let docsFolder = docsURL.appendingPathComponent(AppUISettings.thumbnailFolder).path
        copyFiles(pathFromBundle: folderPath, pathDestDocs: docsFolder)
    }
    
    static func copyFiles(pathFromBundle : String, pathDestDocs: String) {
        let fileManagerIs = FileManager.default
        
        do {
            let filelist = try fileManagerIs.contentsOfDirectory(atPath: pathFromBundle)
            try? fileManagerIs.copyItem(atPath: pathFromBundle, toPath: pathDestDocs)
            
            for filename in filelist {
                if URL.init(string: filename)?.pathExtension == "jpg"  {
                    //resize to 312x390
                    try? fileManagerIs.copyItem(atPath: "\(pathFromBundle)/\(filename)", toPath: "\(pathDestDocs)/\(filename)")
                }
            }
        } catch {
            print("\nError\n")
        }
    }
    
    static func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
