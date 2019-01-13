//
//  DecoratorTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 12/2/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import UIKit

class DecoratorDigitalTimeTableViewCell: DecoratorTableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueSlider: UISlider!
    @IBOutlet var widthSlider: UISlider!
    
    @IBOutlet var horizontalPositionSegment: UISegmentedControl!
    @IBOutlet var verticalPositionSegment: UISegmentedControl!
    @IBOutlet var timeFormatSegment: UISegmentedControl!
    @IBOutlet var timeEffectSegment: UISegmentedControl!
    
    @IBOutlet var materialSegment: UISegmentedControl!
    
    override func transitionToEditMode() {
        self.valueSlider.isHidden = true
    }
    
    override func transitionToNormalMode() {
        self.valueSlider.isHidden = false
    }
    
    @IBAction func editType(sender: UIButton ) {
        self.selectThisCell()
        
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsEditDetailNotificationName, object: nil,
                                        userInfo:["settingType":"textType", "decoratorDigitalTimeTableViewCell":self ])
    }
    
    @IBAction func horizontalPositionSegmentDidChange(sender: UISegmentedControl ) {
        self.selectThisCell()
        
        //debugPrint("segment value:" + String( sender.selectedSegmentIndex ) )
        let clockRingSetting = myClockRingSetting()
        
        switch sender.selectedSegmentIndex {
        case 0:
            clockRingSetting.ringStaticItemHorizontalPosition = .Left
        case 1:
            clockRingSetting.ringStaticItemHorizontalPosition = .Centered
        case 2:
            clockRingSetting.ringStaticItemHorizontalPosition = .Right
        default:
            clockRingSetting.ringStaticItemHorizontalPosition = .None
        }
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"ringStaticItemHorizontalPosition" ])
    }
    
    @IBAction func timeEffectSegmentDidChange(sender: UISegmentedControl ) {
        self.selectThisCell()
        
        //debugPrint("segment value:" + String( sender.selectedSegmentIndex ) )
        let clockRingSetting = myClockRingSetting()
        
        clockRingSetting.ringStaticEffects = DigitalTimeEffects.userSelectableValues[sender.selectedSegmentIndex]
    
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"ringStaticEffects" ])
    }
    
    @IBAction func verticalPositionSegmentDidChange(sender: UISegmentedControl ) {
        self.selectThisCell()
        
        //debugPrint("segment value:" + String( sender.selectedSegmentIndex ) )
        let clockRingSetting = myClockRingSetting()
        
        switch sender.selectedSegmentIndex {
        case 0:
            clockRingSetting.ringStaticItemVerticalPosition = .Top
        case 1:
            clockRingSetting.ringStaticItemVerticalPosition = .Centered
        case 2:
            clockRingSetting.ringStaticItemVerticalPosition = .Bottom
        default:
            clockRingSetting.ringStaticItemVerticalPosition = .None
        }
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"ringStaticItemVerticalPosition" ])
    }
    
    @IBAction func materialSegmentDidChange(sender: UISegmentedControl ) {
        self.selectThisCell()
        
        //debugPrint("segment value:" + String( sender.selectedSegmentIndex ) )
        let clockRingSetting = myClockRingSetting()
        clockRingSetting.ringMaterialDesiredThemeColorIndex = sender.selectedSegmentIndex
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"ringMaterialDesiredThemeColorIndex" ])
    }
    
    @IBAction func formatSegmentDidChange(sender: UISegmentedControl ) {
        self.selectThisCell()
        
        //debugPrint("segment value:" + String( sender.selectedSegmentIndex ) )
        let clockRingSetting = myClockRingSetting()
        clockRingSetting.ringStaticTimeFormat = DigitalTimeFormats.userSelectableValues[sender.selectedSegmentIndex]
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"ringStaticTimeFormat" ])
    }
    
    @IBAction func widthSliderValueDidChange(sender: UISlider ) {
        self.selectThisCell()
        
        //debugPrint("slider value:" + String( sender.value ) )
        let clockRingSetting = myClockRingSetting()
        
        let roundedValue = Float(round(100*sender.value)/100)
        if roundedValue != clockRingSetting.ringWidth {
            clockRingSetting.ringWidth = sender.value
            NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                            userInfo:["settingType":"ringWidth" ])
        }
    }
    
    @IBAction func sliderValueDidChange(sender: UISlider ) {
        self.selectThisCell()
        
        //debugPrint("slider value:" + String( sender.value ) )
        let clockRingSetting = myClockRingSetting()
        
        let roundedValue = Float(round(100*sender.value)/100)
        if roundedValue != clockRingSetting.textSize {
            //debugPrint("new value:" + String( roundedValue ) )
            clockRingSetting.textSize = roundedValue
            NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                            userInfo:["settingType":"textSize" ])
        }
        
    }
    
    func fontChosen( textType: NumberTextTypes ) {
        //debugPrint("fontChosen" + NumberTextNode.descriptionForType(textType))
        
        let clockRingSetting = myClockRingSetting()
        clockRingSetting.textType = textType
        self.titleLabel.text = titleText( clockRingSetting: clockRingSetting )
        
        NotificationCenter.default.post(name: DecoratorPreviewController.ringSettingsChangedNotificationName, object: nil,
                                        userInfo:["settingType":"textType" ])
    }
    
    func titleText( clockRingSetting: ClockRingSetting ) -> String {
        return ClockRingSetting.descriptionForRingType(clockRingSetting.ringType) + " : " + NumberTextNode.descriptionForType(clockRingSetting.textType)
    }
    
    override func setupUIForClockRingSetting( clockRingSetting: ClockRingSetting ) {
        super.setupUIForClockRingSetting(clockRingSetting: clockRingSetting)
    
        self.titleLabel.text = titleText(clockRingSetting: clockRingSetting)
        
        valueSlider.minimumValue = AppUISettings.ringSettigsSliderTextMin
        valueSlider.maximumValue = AppUISettings.ringSettigsSliderTextMax
        
        valueSlider.value = clockRingSetting.textSize
        widthSlider.value = clockRingSetting.ringWidth
        
        self.materialSegment.selectedSegmentIndex = clockRingSetting.ringMaterialDesiredThemeColorIndex
        
        switch clockRingSetting.ringStaticItemHorizontalPosition {
        case .Left:
            horizontalPositionSegment.selectedSegmentIndex = 0
        case .Centered:
            horizontalPositionSegment.selectedSegmentIndex = 1
        case .Right:
            horizontalPositionSegment.selectedSegmentIndex = 2
        case .None:
            horizontalPositionSegment.isEnabled = true //TODO: not sure what to put here
        }
        
        switch clockRingSetting.ringStaticItemVerticalPosition {
        case .Top:
            verticalPositionSegment.selectedSegmentIndex = 0
        case .Centered:
            verticalPositionSegment.selectedSegmentIndex = 1
        case .Bottom:
            verticalPositionSegment.selectedSegmentIndex = 2
        case .None:
            verticalPositionSegment.isEnabled = true //TODO: not sure what to put here
        }
        
        timeEffectSegment.removeAllSegments()
        for (index, item) in DigitalTimeEffects.userSelectableValues.enumerated() {
            timeEffectSegment.insertSegment(withTitle: item.rawValue, at: index, animated: false)
        }
        if let indexFound = DigitalTimeEffects.userSelectableValues.firstIndex(of: clockRingSetting.ringStaticEffects) {
            timeEffectSegment.selectedSegmentIndex = indexFound
        }
        
        timeFormatSegment.removeAllSegments()
        for (index, item) in DigitalTimeFormats.userSelectableValues.enumerated() {
            timeFormatSegment.insertSegment(withTitle: item.rawValue, at: index, animated: false)
        }
        if let indexFound = DigitalTimeFormats.userSelectableValues.firstIndex(of: clockRingSetting.ringStaticTimeFormat) {
            timeFormatSegment.selectedSegmentIndex = indexFound
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
