//
//  TextEditViewController.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class TextEditViewController: EditValueChildViewController, UITextFieldDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func stepperClicked(_ sender: Any) {
        text = textType?.text(stepper.value)
        textField.text = text
        (parent as! EditValueViewController).saveButton.isEnabled = true
    }
    
    var textType: TextType?
    var name: String?
    var text: String?
    var detail: String?
    var validText: TextType.ValidationResult {
        return textType!.validate(text!)
    }
    var ignore: Bool {
        return (parent as! EditValueViewController).ignoreStatus == IgnoreStatus.ignore(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = name! + ":"
        label.sizeToFit()
        textField.delegate = self
        textField.text = text
        if !(detail?.isEmpty)! {
            let l = UILabel()
            l.text = detail
            l.textColor = .darkGray
            l.sizeToFit()
            textField.rightView = l
            textField.rightViewMode = .always
        }
        if (textType?.isNumeric)! {
            textField.keyboardType = .decimalPad
            stepper.autorepeat = true
            stepper.minimumValue = 0
            stepper.stepValue = (textType?.increment)!
        }
        else {
            stepper.isHidden = true
        }
        setValueIgnored(ignore)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        text = text?.replacingCharacters(in: Range(range, in: text!)!, with: string)
        validateText()
        return true
    }
    
    override func setValueIgnored(_ flag: Bool) {
        if flag {
            textField.isEnabled = false
            textField.rightView?.isHidden = true
            textField.text = IgnoreStatus.ignored
            textField.textColor = UIColor.lightGray
            textField.resignFirstResponder()
            errorLabel.isHidden = true
            stepper.isHidden = true
        }
        else {
            textField.isEnabled = true
            textField.rightView?.isHidden = false
            if textField.text == IgnoreStatus.ignored {
                textField.text = ""
                text = ""
            }
            else {
                textField.text = text
            }
            validateText()
            textField.becomeFirstResponder()
            if (textType?.isNumeric)! {
                stepper.isHidden = false
            }
        }
    }
    
    private func validateText() {
        guard !ignore else {return}
        let parentVc = parent as! EditValueViewController
        let valid = validText
        if valid == .success {
            textField.textColor = UIColor.darkText
            parentVc.saveButton.isEnabled = true
            errorLabel.isHidden = true
            if (textType?.isNumeric)! {
                stepper.value = Double(text!) ?? 0
            }
        }
        else {
            textField.textColor = UIColor.red
            parentVc.saveButton.isEnabled = false
            errorLabel.isHidden = false
            switch valid {
            case .emptyNotOk:
                errorLabel.text = "Input cannot be empty."
            case .notCorrectType:
                errorLabel.text = "Expected type: \(textType!.type!.rawValue)"
            default:
                break
            }
        }
    }
}
