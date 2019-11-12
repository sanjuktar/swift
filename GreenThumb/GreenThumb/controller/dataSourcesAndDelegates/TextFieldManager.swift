//
//  TextFieldManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol TextFieldManager: UITextFieldDelegate, KeyboardHandler {
    associatedtype D:ObjectDetail
    var object: D.T? {get set}
    var textFields: [UITextField:D] {get set}
    func modifyObject(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

extension TextFieldManager {
    func modifyObject(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let detail = textFields[textField] else {return false}
        let text = ((textField.text! as NSString).replacingCharacters(in: range, with: string))
        if !detail.modify(object!, with: text)  {
            return false
        }
        return true
    }
    
    private func addToTextFields(_ textField: UITextField, detail: D) {
        if let field = textFieldFor(detail) {
            textFields.remove(at: textFields.index(forKey: field)!)
        }
        textFields[textField] = detail
    }
    
    private func textFieldFor(_ item: D) -> UITextField? {
        for t in textFields.keys {
            if textFields[t] == item {
                return t
            }
        }
        return nil
    }
}
