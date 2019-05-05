//
//  FaceLayer.swift
//  Clockology
//
//  Created by Mike Hill on 5/4/19.
//  Copyright © 2019 Mike Hill. All rights reserved.
//

//import Cocoa
import SpriteKit

enum FaceLayerTypes: String {
    case SecondHand,
    MinuteHand,
    HourHand,
    ImageTexture,
    ColorTexture,
    GradientTexture,
    ShapeRing,
    NumberRing
    
    static let userSelectableValues = [
        SecondHand, MinuteHand, HourHand, ImageTexture, ColorTexture, GradientTexture, ShapeRing, NumberRing]
}

class FaceLayerOptions: NSObject {
    //will be subclassed for each type
    func serializedSettings() -> NSDictionary {
        return [String:AnyObject]() as NSDictionary
    }
}

class FaceLayer: NSObject {
    // stuff that applies to all layers

    var layerType: FaceLayerTypes = .SecondHand
    var alpha: Float = 1.0
    //scale
    //position
    
    // specific to each layer by type
    var layerOptions: FaceLayerOptions

    init(layerType: FaceLayerTypes, alpha: Float, layerOptions: FaceLayerOptions) {
        self.layerType = layerType
        self.alpha = alpha
        self.layerOptions = layerOptions
    
        super.init()
    }
    
    static func defaults() -> FaceLayer {
        return FaceLayer.init( layerType: .SecondHand, alpha: 1.0 ,layerOptions: FaceLayerOptions() )
    }
    
    //init from JSON, ( in from txt files )
    init(jsonObj: JSON ) {
        let layerTypeString = jsonObj["layerType"].stringValue
        self.layerType = FaceLayerTypes(rawValue: layerTypeString)!
        self.alpha = NSObject.floatValueForJSONObj(jsonObj: jsonObj, defaultVal: 1.0, key: "alpha")
        
        //init layerOptions depending on type
        self.layerOptions = FaceLayerOptions()
        if self.layerType == .ShapeRing {
            //TODO: grag this from the JSON
            self.layerOptions = ShapeLayerOptions.init(jsonObj: jsonObj["layerOptions"])
        }
        
        super.init()
    }
    
    //out to serialized . text files
    func serializedSettings() -> NSDictionary {
        var serializedDict = [String:AnyObject]()

        serializedDict[ "layerType" ] = self.layerType.rawValue as AnyObject
        serializedDict[ "alpha" ] = self.alpha.description as AnyObject
        serializedDict[ "layerOptions" ] = self.layerOptions.serializedSettings()

        return serializedDict as NSDictionary
    }
    
    static func descriptionForType(_ layerType: FaceLayerTypes) -> String {
        var typeDescription = ""
        
        if (layerType == .SecondHand)  { typeDescription = "Second Hand" }
        if (layerType == .MinuteHand)  { typeDescription = "Minute Hand" }
        if (layerType == .HourHand)  { typeDescription = "Hour Hand" }
        
        if (layerType == .NumberRing)  { typeDescription = "Number Ring" }
        if (layerType == .ShapeRing)  { typeDescription = "Shape Ring" }
        
        if (layerType == .ImageTexture)  { typeDescription = "Image Texture" }
        if (layerType == .ColorTexture)  { typeDescription = "Color Texture" }
        if (layerType == .GradientTexture)  { typeDescription = "Gradient Texture" }
        
        return typeDescription
    }
}
