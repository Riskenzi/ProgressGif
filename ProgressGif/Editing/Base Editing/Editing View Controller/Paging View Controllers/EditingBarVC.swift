//
//  EditingBarVC.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit

protocol EditingBarChanged: class {
    func barHeightChanged(to height: Int)
    func foregroundColorChanged(to color: UIColor, hex: String)
    func backgroundColorChanged(to color: UIColor, hex: String)
}

// MARK: - the first option screen
/// controls bar properties like height and color
class EditingBarVC: UIViewController {
    
    weak var editingBarChanged: EditingBarChanged?
      
    var originalBarHeight = 5
    var originalBarForegroundColor = UIColor.yellow
    var originalBarBackgroundColor = UIColor.yellow
    
    @IBOutlet weak var heightBaseView: UIView!
    @IBOutlet weak var heightNumberStepper: NumberStepper!
    
    @IBOutlet weak var foregroundBaseView: UIView!
    @IBOutlet weak var foregroundColorButton: UIButton!
    @IBAction func foregroundColorPressed(_ sender: Any) {
        self.displayColorPicker(originalColor: originalBarForegroundColor, colorPickerType: .barForeground, sourceView: foregroundColorButton)
    }
    
    @IBOutlet weak var backgroundBaseView: UIView!
    @IBOutlet weak var backgroundColorButton: UIButton!
    
    @IBAction func backgroundColorPressed(_ sender: Any) {
        self.displayColorPicker(originalColor: originalBarBackgroundColor, colorPickerType: .barBackground, sourceView: backgroundColorButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightBaseView.layer.cornerRadius = 6
        foregroundBaseView.layer.cornerRadius = 6
        backgroundBaseView.layer.cornerRadius = 6
        
        foregroundColorButton.layer.cornerRadius = 6
        backgroundColorButton.layer.cornerRadius = 6
        
        foregroundColorButton.addBorder(width: 3, color: UIColor.lightGray)
        backgroundColorButton.addBorder(width: 3, color: UIColor.lightGray)
        
        setUpConfiguration()
    }
    
    func setUpConfiguration() {
        heightNumberStepper.value = originalBarHeight
        foregroundColorButton.backgroundColor = originalBarForegroundColor
        backgroundColorButton.backgroundColor = originalBarBackgroundColor
        
        heightNumberStepper.numberStepperChanged = self
    }
    
}

extension EditingBarVC: NumberStepperChanged {
    func valueChanged(to value: Int, stepperType: NumberStepperType) {
        editingBarChanged?.barHeightChanged(to: value)
    }
}

extension EditingBarVC: ColorChanged {
    func colorChanged(color: UIColor, hexCode: String, colorPickerType: ColorPickerType) {
        if colorPickerType == .barForeground {
            originalBarForegroundColor = color
            foregroundColorButton.backgroundColor = color
            editingBarChanged?.foregroundColorChanged(to: color, hex: hexCode)
        } else if colorPickerType == .barBackground {
            originalBarBackgroundColor = color
            backgroundColorButton.backgroundColor = color
            editingBarChanged?.backgroundColorChanged(to: color, hex: hexCode)
        }
    }
}

extension EditingBarVC: UIPopoverPresentationControllerDelegate {
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
}



