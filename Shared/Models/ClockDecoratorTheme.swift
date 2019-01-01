//
//  ClockDecoratorTheme.swift
//  SwissClock
//
//  Created by Mike Hill on 11/12/15.
//  Copyright © 2015 Mike Hill. All rights reserved.
//

//import Cocoa
import SceneKit
import SpriteKit

class ClockDecoratorTheme: NSObject {
    //model object to hold instances of a clock decorator theme
    
    var title:String
    
    var faceBackgroundType:FaceBackgroundTypes
    var ringRenderShape:RingRenderShapes
    
    // types
    var hourHandType:HourHandTypes
    var minuteHandType:MinuteHandTypes
    var secondHandType:SecondHandTypes
    var shouldShowHandOutlines: Bool
    
    //
    
    //options
    var minuteHandMovement:MinuteHandMovements
    var secondHandMovement:SecondHandMovements
    var shouldShowRomanNumeralText: Bool
    
    //tweaks
    var ringSettings: [ClockRingSetting]
    
    //NOTE: ANY CHANGES HERE NEED TO BE MADE IN CLOCKFACESETTINGS
    
    init(jsonObj: JSON ) {
        self.title = jsonObj["title"].stringValue
        
        if (jsonObj["faceBackgroundType"] != JSON.null) {
            self.faceBackgroundType = FaceBackgroundTypes(rawValue: jsonObj["faceBackgroundType"].stringValue)!
        } else {
            self.faceBackgroundType = .FaceBackgroundTypeFilled
        }
        
        if (jsonObj["ringRenderShape"] != JSON.null) {
            self.ringRenderShape = RingRenderShapes(rawValue: jsonObj["ringRenderShape"].stringValue)!
        } else {
            self.ringRenderShape = .RingRenderShapeCircle
        }
        
        self.hourHandType = HourHandTypes(rawValue: jsonObj["hourHandType"].stringValue)!
        self.minuteHandType = MinuteHandTypes(rawValue: jsonObj["minuteHandType"].stringValue)!
        self.secondHandType = SecondHandTypes(rawValue: jsonObj["secondHandType"].stringValue)!
        
        if (jsonObj["shouldShowHandOutlines"] != JSON.null) {
            self.shouldShowHandOutlines = jsonObj[ "shouldShowHandOutlines" ].boolValue
        } else {
            self.shouldShowHandOutlines = false
        }
        
        if (jsonObj["minuteHandMovement"] != JSON.null) {
            self.minuteHandMovement = MinuteHandMovements(rawValue: jsonObj["minuteHandMovement"].stringValue)!
        } else {
            self.minuteHandMovement = MinuteHandMovements.MinuteHandMovementStep
        }
        self.secondHandMovement = SecondHandMovements(rawValue: jsonObj["secondHandMovement"].stringValue)!
        self.shouldShowRomanNumeralText = jsonObj[ "shouldShowRomanNumeralText" ].boolValue
        
        
        // parse the ringSettings
        self.ringSettings = [ClockRingSetting]()
        
        if let ringSettingsSerializedArray = jsonObj["ringSettings"].array {
            for ringSettingSerialized in ringSettingsSerializedArray {
                let newRingSetting = ClockRingSetting.init(jsonObj: ringSettingSerialized)
                self.ringSettings.append( newRingSetting )
            }
        }
        
        super.init()
    }
    
    func filename()->String {
        let newName = self.title.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
        return "decoratorTheme-" + newName
    }

}
