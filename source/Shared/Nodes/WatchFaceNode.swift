//
//  WatchFaceNode.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 11/9/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import Foundation
import SpriteKit

class WatchFaceNode: SKShapeNode {
    
    var clockFaceSettings: ClockFaceSetting = ClockFaceSetting.defaults()
    
    enum PartsZPositions: Int {
        case background = 0,
        backgroundShape,
        complications,
        hourHand,
        minuteHand,
        secondHand
    }
    
    init(clockSetting: ClockSetting, size: CGSize) {
        super.init()
        
        self.name = "watchFaceNode"
        
        //nothing to without these settings
        guard let clockFaceSettings = clockSetting.clockFaceSettings else { return }
        self.clockFaceSettings = clockFaceSettings
        
        var renderShadows = false
        let shadowMaterial = "#111111AA"
        let shadowChildZposition:CGFloat = -0.5
        var shadowColor = SKColor.init(hexString: shadowMaterial)
        shadowColor = shadowColor.withAlphaComponent(0.4)
        let shadowLineWidth:CGFloat = 2.0
        
        let backgroundNode = FaceBackgroundNode.init(backgroundType: FaceBackgroundTypes.FaceBackgroundTypeFilled , material: clockSetting.clockCasingMaterialName)
        backgroundNode.name = "background"
        backgroundNode.zPosition = CGFloat(PartsZPositions.background.rawValue)
        
        self.addChild(backgroundNode)
        
        let backgroundShapeNode = FaceBackgroundNode.init(backgroundType: clockSetting.faceBackgroundType , material: clockSetting.clockFaceMaterialName, material2: clockSetting.clockCasingMaterialName)
        backgroundShapeNode.name = "backgroundShape"
        backgroundShapeNode.zPosition = CGFloat(PartsZPositions.backgroundShape.rawValue)
        
        self.addChild(backgroundShapeNode)
        
        var secondHandStrokeColor = SKColor.init(hexString: clockFaceSettings.secondHandMaterialName)
        //allow for dials to have outlines
        if (SecondHandTypes.isDialType(type: clockFaceSettings.secondHandType) && clockFaceSettings.shouldShowHandOutlines) {
            secondHandStrokeColor = SKColor.init(hexString: clockFaceSettings.handOutlineMaterialName)
        }
        let secHandNode = SecondHandNode.init(secondHandType: clockFaceSettings.secondHandType, material: clockFaceSettings.secondHandMaterialName, strokeColor: secondHandStrokeColor, lineWidth: 1.0)
        secHandNode.name = "secondHand"
        secHandNode.zPosition = CGFloat(PartsZPositions.secondHand.rawValue)
        
        self.addChild(secHandNode)
        
        //whitelist rendring shadows
        let typesThatShouldHaveShadows = [SecondHandTypes.SecondHandTypeBlocky, SecondHandTypes.SecondHandTypeFlatDial,
                                          SecondHandTypes.SecondHandTypePointy, SecondHandTypes.SecondHandTypePointy, SecondHandTypes.SecondHandTypeSquaredHole]
        if (typesThatShouldHaveShadows.firstIndex(of: clockFaceSettings.secondHandType) != nil) {
            renderShadows = true
        }
        
        if renderShadows {
            let secHandShadowNode = SecondHandNode.init(secondHandType: clockFaceSettings.secondHandType, material: shadowMaterial, strokeColor: shadowColor, lineWidth: shadowLineWidth)
            secHandShadowNode.position = CGPoint.init(x: 0, y: 0)
            secHandShadowNode.name = "secondHandShadow"
            secHandShadowNode.zPosition = shadowChildZposition
            secHandNode.addChild(secHandShadowNode)
        }
        
        var minuteHandStrokeColor = SKColor.init(hexString: clockFaceSettings.minuteHandMaterialName)
        if (clockFaceSettings.shouldShowHandOutlines) {
            minuteHandStrokeColor = SKColor.init(hexString: clockFaceSettings.handOutlineMaterialName)
        }
        let minHandNode = MinuteHandNode.init(minuteHandType: clockFaceSettings.minuteHandType, material: clockFaceSettings.minuteHandMaterialName, strokeColor: minuteHandStrokeColor, lineWidth: 1.0)
        minHandNode.name = "minuteHand"
        minHandNode.zPosition = CGFloat(PartsZPositions.minuteHand.rawValue)
        
        self.addChild(minHandNode)
        
        if renderShadows {
            let minHandShadowNode = MinuteHandNode.init(minuteHandType: clockFaceSettings.minuteHandType, material: shadowMaterial, strokeColor: shadowColor, lineWidth: shadowLineWidth)
            minHandShadowNode.position = CGPoint.init(x: 0, y: 0)
            minHandShadowNode.name = "minuteHandShadow"
            minHandShadowNode.zPosition = shadowChildZposition
            minHandNode.addChild(minHandShadowNode)
        }
        
        var hourHandStrokeColor = SKColor.init(hexString: clockFaceSettings.hourHandMaterialName)
        if (clockFaceSettings.shouldShowHandOutlines) {
            hourHandStrokeColor = SKColor.init(hexString: clockFaceSettings.handOutlineMaterialName)
        }
        
        let hourHandNode = HourHandNode.init(hourHandType: clockFaceSettings.hourHandType, material: clockFaceSettings.hourHandMaterialName, strokeColor: hourHandStrokeColor, lineWidth: 1.0)
        hourHandNode.name = "hourHand"
        hourHandNode.zPosition = CGFloat(PartsZPositions.hourHand.rawValue)
        
        self.addChild(hourHandNode)
        
        if renderShadows {
            let hourHandShadowNode = HourHandNode.init(hourHandType: clockFaceSettings.hourHandType, material: shadowMaterial, strokeColor: shadowColor, lineWidth: shadowLineWidth)
            hourHandShadowNode.position = CGPoint.init(x: 0, y: 0)
            hourHandShadowNode.name = "hourHandShadow"
            hourHandShadowNode.zPosition = shadowChildZposition
            hourHandNode.addChild(hourHandShadowNode)
        }
        
        let ringShapePath = WatchFaceNode.getShapePath( ringRenderShape: clockFaceSettings.ringRenderShape )
        
        var currentDistance = Float(1.0)
        //loop through ring settings and render rings from outside to inside
        for ringSetting in clockFaceSettings.ringSettings {
            
            let desiredMaterialIndex = ringSetting.ringMaterialDesiredThemeColorIndex
            var material = ""
            if (desiredMaterialIndex<=clockFaceSettings.ringMaterials.count-1) {
                material = clockFaceSettings.ringMaterials[desiredMaterialIndex]
            } else {
                material = clockFaceSettings.ringMaterials[clockFaceSettings.ringMaterials.count-1]
            }
            
            generateRingNode(
                self,
                patternTotal: ringSetting.ringPatternTotal,
                patternArray: ringSetting.ringPattern,
                ringType: ringSetting.ringType,
                material: material,
                currentDistance: currentDistance,
                clockFaceSettings: clockFaceSettings,
                ringSettings: ringSetting,
                renderNumbers: true,
                renderShapes: true,
                ringShape: ringShapePath)
            
            //move it closer to center
            currentDistance = currentDistance - ringSetting.ringWidth
        }
        
    }
    
    func generateRingNode( _ clockFaceNode: SKShapeNode, patternTotal: Int, patternArray: [Int], ringType: RingTypes, material: String, currentDistance: Float, clockFaceSettings: ClockFaceSetting, ringSettings: ClockRingSetting, renderNumbers: Bool, renderShapes: Bool, ringShape: UIBezierPath ) {
        
        let ringNode = SKNode()
        ringNode.name = "ringNode"
        clockFaceNode.addChild(ringNode)
        
        //optional stroke color
        var strokeColor:SKColor? = nil
        if (ringSettings.shouldShowTextOutline) {
            let strokeMaterial = clockFaceSettings.ringMaterials[ringSettings.textOutlineDesiredThemeColorIndex]
            strokeColor = SKColor.init(hexString: strokeMaterial)
        }
        
        //just exit for spacer
        if (ringType == RingTypes.RingTypeSpacer) { return }
        
        //draw any special items
        if (ringType == RingTypes.RingTypeDigitalTime) {
            //draw it
            let digitalTimeNode = DigitalTimeNode.init(digitalTimeTextType: ringSettings.textType, timeFormat: ringSettings.ringStaticTimeFormat, textSize: ringSettings.textSize,
                                                       effect: ringSettings.ringStaticEffects, horizontalPosition: ringSettings.ringStaticItemHorizontalPosition, fillColor: SKColor.init(hexString: material), strokeColor: strokeColor)
            
            digitalTimeNode.zPosition = CGFloat(PartsZPositions.complications.rawValue)
            
            var xPos:CGFloat = 0
            var yPos:CGFloat = 0
            let xDist = 105 * CGFloat(currentDistance) - CGFloat(ringSettings.textSize * 15)
            let yDist = 130 * CGFloat(currentDistance) - CGFloat(ringSettings.textSize * 10)
            
            if (ringSettings.ringStaticItemHorizontalPosition == .Left) {
                xPos = -xDist
            }
            if (ringSettings.ringStaticItemHorizontalPosition == .Right) {
                xPos = xDist
            }
            if (ringSettings.ringStaticItemVerticalPosition == .Top) {
                yPos = yDist
            }
            if (ringSettings.ringStaticItemVerticalPosition == .Bottom) {
                yPos = -yDist
            }
            //horizontalPosition: .Right, verticalPosition: .Top
            digitalTimeNode.position = CGPoint.init(x: xPos, y: yPos)
            
            ringNode.addChild(digitalTimeNode)
            
            return
        }
        
        //draw items that loop
        
        // exit if pattern array is empty
        if (patternArray.count == 0) { return }
        
        var patternCounter = 0
        
        generateLoop: for outerRingIndex in 0...(patternTotal-1) {
            //dont draw when pattern == 0
            var doDraw = true
            if ( patternArray[patternCounter] == 0) { doDraw = false }
            patternCounter = patternCounter + 1
            if (patternCounter >= patternArray.count) { patternCounter = 0 }
            
            if (!doDraw) { continue }
            
            var outerRingNode = SKNode.init()
            
            //get new position
            let percentOfPath:CGFloat = CGFloat(outerRingIndex) / CGFloat(patternTotal)
            let distanceMult = CGFloat(currentDistance)
            guard let newPos = ringShape.point(at: percentOfPath) else { return }
            let scaledPoint = newPos.applying(CGAffineTransform.init(scaleX: distanceMult, y: distanceMult))
            
            if (renderNumbers && ringType == RingTypes.RingTypeTextNode || renderNumbers && ringType == RingTypes.RingTypeTextRotatingNode) {
                //print("patternDraw")
                
                //numbers
                var numberToRender = outerRingIndex
                if numberToRender == 0 { numberToRender = patternTotal }
                
                //force small totals to show as 12s
                if patternTotal < 12 {
                    numberToRender = numberToRender * ( 12 / patternTotal )
                }
                
                outerRingNode  = NumberTextNode.init(
                    numberTextType: ringSettings.textType,
                    textSize: ringSettings.textSize,
                    currentNum: numberToRender,
                    totalNum: patternTotal,
                    shouldDisplayRomanNumerals: clockFaceSettings.shouldShowRomanNumeralText,
                    pivotMode: 0,
                    fillColor: SKColor.init(hexString: material),
                    strokeColor: strokeColor
                )
                
                ringNode.name = "textRingNode"
                
                if ringType == .RingTypeTextRotatingNode {
                    let angle = atan2(scaledPoint.y, scaledPoint.x)
                    outerRingNode.zRotation = angle - CGFloat(Double.pi/2)
                }
                
            }
            if (ringType == RingTypes.RingTypeShapeNode) {
                //shape
                outerRingNode = FaceIndicatorNode.init(indicatorType:  ringSettings.indicatorType, size: ringSettings.indicatorSize, fillColor: SKColor.init(hexString: material))
                outerRingNode.name = "indicatorNode"
                
                let angle = atan2(scaledPoint.y, scaledPoint.x)
                outerRingNode.zRotation = angle + CGFloat(Double.pi/2)
            }
            
            outerRingNode.zPosition = 1
            outerRingNode.position = scaledPoint
            
            ringNode.addChild(outerRingNode)
        }
    }
    
    func hideHands() {
        if let secondHand = self.childNode(withName: "secondHand") {
            secondHand.isHidden = true
        }
        if let minuteHand = self.childNode(withName: "minuteHand") {
            minuteHand.isHidden = true
        }
        if let hourHand = self.childNode(withName: "hourHand") {
            hourHand.isHidden = true
        }
    }
    
    func positionHands( sec: CGFloat, min: CGFloat, hour: CGFloat ) {
        positionHands(sec: sec, min: min, hour: hour, force: false)
    }
    
    func positionHands( sec: CGFloat, min: CGFloat, hour: CGFloat, force: Bool ) {
        
        if let secondHand = self.childNode(withName: "secondHand") as? SecondHandNode {
            secondHand.positionHands(sec: sec, secondHandMovement: clockFaceSettings.secondHandMovement, force: force)
        }
        
        if let minuteHand = self.childNode(withName: "minuteHand") as? MinuteHandNode {
            minuteHand.positionHands(sec: sec, min: min, minuteHandMovement: clockFaceSettings.minuteHandMovement, force: force)
        }
        
        if let hourHand = self.childNode(withName: "hourHand") as? HourHandNode {
            hourHand.positionHands(min: min, hour: hour, force: force)
        }
    }
    
    func setToTime() {
        setToTime( force: false)
    }
    
    func setToTime( force: Bool ) {
        // Called before each frame is rendered
        let date = ClockTimer.currentDate
        let calendar = Calendar.current
        
        let hour = CGFloat(calendar.component(.hour, from: date))
        let minutes = CGFloat(calendar.component(.minute, from: date))
        let seconds = CGFloat(calendar.component(.second, from: date))
        
        //normalize 24 hour to 12
        var hour12 = hour
        if hour12>=12 { hour12 -= 12 }
        
        positionHands(sec: seconds, min: minutes, hour: hour12, force: force)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getShapePath( ringRenderShape: RingRenderShapes) -> UIBezierPath {
        let totalWidth = CGFloat(SKWatchScene.sizeMulitplier * 2)
        
        let ringShapePath = UIBezierPath()
        
        if ringRenderShape == .RingRenderShapeRoundedRect {
            ringShapePath.move(to: CGPoint(x: 0, y: -100))
            ringShapePath.addLine(to: CGPoint(x: 69.43, y: -100))
            ringShapePath.addCurve(to: CGPoint(x: 86.6, y: -98.69), controlPoint1: CGPoint(x: 78.23, y: -100), controlPoint2: CGPoint(x: 82.63, y: -100))
            ringShapePath.addLine(to: CGPoint(x: 87.37, y: -98.5))
            ringShapePath.addCurve(to: CGPoint(x: 98.5, y: -87.37), controlPoint1: CGPoint(x: 92.54, y: -96.62), controlPoint2: CGPoint(x: 96.62, y: -92.54))
            ringShapePath.addCurve(to: CGPoint(x: 100, y: -69.43), controlPoint1: CGPoint(x: 100, y: -82.63), controlPoint2: CGPoint(x: 100, y: -78.23))
            ringShapePath.addLine(to: CGPoint(x: 100, y: 69.43))
            ringShapePath.addCurve(to: CGPoint(x: 98.69, y: 86.6), controlPoint1: CGPoint(x: 100, y: 78.23), controlPoint2: CGPoint(x: 100, y: 82.63))
            ringShapePath.addLine(to: CGPoint(x: 98.5, y: 87.37))
            ringShapePath.addCurve(to: CGPoint(x: 87.37, y: 98.5), controlPoint1: CGPoint(x: 96.62, y: 92.54), controlPoint2: CGPoint(x: 92.54, y: 96.62))
            ringShapePath.addCurve(to: CGPoint(x: 69.43, y: 100), controlPoint1: CGPoint(x: 82.63, y: 100), controlPoint2: CGPoint(x: 78.23, y: 100))
            ringShapePath.addLine(to: CGPoint(x: -69.43, y: 100))
            ringShapePath.addCurve(to: CGPoint(x: -86.6, y: 98.69), controlPoint1: CGPoint(x: -78.23, y: 100), controlPoint2: CGPoint(x: -82.63, y: 100))
            ringShapePath.addLine(to: CGPoint(x: -87.37, y: 98.5))
            ringShapePath.addCurve(to: CGPoint(x: -98.5, y: 87.37), controlPoint1: CGPoint(x: -92.54, y: 96.62), controlPoint2: CGPoint(x: -96.62, y: 92.54))
            ringShapePath.addCurve(to: CGPoint(x: -100, y: 69.43), controlPoint1: CGPoint(x: -100, y: 82.63), controlPoint2: CGPoint(x: -100, y: 78.23))
            ringShapePath.addLine(to: CGPoint(x: -100, y: -69.43))
            ringShapePath.addCurve(to: CGPoint(x: -98.69, y: -86.6), controlPoint1: CGPoint(x: -100, y: -78.23), controlPoint2: CGPoint(x: -100, y: -82.63))
            ringShapePath.addLine(to: CGPoint(x: -98.5, y: -87.37))
            ringShapePath.addCurve(to: CGPoint(x: -87.37, y: -98.5), controlPoint1: CGPoint(x: -96.62, y: -92.54), controlPoint2: CGPoint(x: -92.54, y: -96.62))
            ringShapePath.addCurve(to: CGPoint(x: -69.43, y: -100), controlPoint1: CGPoint(x: -82.63, y: -100), controlPoint2: CGPoint(x: -78.23, y: -100))
            ringShapePath.close()
            ringShapePath.apply(CGAffineTransform.init(scaleX: 1, y: -1.275)) //flip and stretch
        }
        
        if ringRenderShape == .RingRenderShapeOval {
            ringShapePath.addArc(withCenter: CGPoint.zero, radius: totalWidth/2, startAngle: CGFloat(Double.pi/2), endAngle: -CGFloat(Double.pi*2)+CGFloat(Double.pi/2), clockwise: false) //reversed, but works
            ringShapePath.apply(CGAffineTransform.init(scaleX: 1.0, y: 1.27))  //scale/stratch
        }
        
        if ringRenderShape == .RingRenderShapeCircle {
            ringShapePath.addArc(withCenter: CGPoint.zero, radius: totalWidth/2, startAngle: CGFloat(Double.pi/2), endAngle: -CGFloat(Double.pi*2)+CGFloat(Double.pi/2), clockwise: false) //reversed, but works
        }
        
        // STAR ?
        /*
         ringShapePath.move(to: CGPoint(x: 144, y: 17.72))
         ringShapePath.addLine(to: CGPoint(x: 191.52, y: 87.06))
         ringShapePath.addLine(to: CGPoint(x: 272.15, y: 110.83))
         ringShapePath.addLine(to: CGPoint(x: 220.89, y: 177.45))
         ringShapePath.addLine(to: CGPoint(x: 223.2, y: 261.48))
         ringShapePath.addLine(to: CGPoint(x: 144, y: 233.32))
         ringShapePath.addLine(to: CGPoint(x: 64.8, y: 261.48))
         ringShapePath.addLine(to: CGPoint(x: 67.11, y: 177.45))
         ringShapePath.addLine(to: CGPoint(x: 15.85, y: 110.83))
         ringShapePath.addLine(to: CGPoint(x: 96.48, y: 87.06))
         ringShapePath.addLine(to: CGPoint(x: 144, y: 17.72))
         
         ringShapePath.apply(CGAffineTransform.init(rotationAngle: CGFloat.pi)) //rot
         ringShapePath.apply(CGAffineTransform.init(scaleX: -0.9, y: 0.9))  //scale/stratch
         ringShapePath.apply(CGAffineTransform.init(translationX: -130.0, y: 130.0)) //repos
         */
        
        return ringShapePath
    }
    
    
}

