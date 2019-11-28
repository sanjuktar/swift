//
//  DetailTextFieldDelegate.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/14/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class DetailTextFieldDelegate<DetailType:ObjectDetail>: NSObject, TextFieldDelegate {
    var textFields: [UITextField : DetailType] = [:]
    var detailsObject: DetailType.ObjectType
    var parent: EditableTableViewController?
    
    init(_ object: DetailType.ObjectType, _ parentVC: EditableTableViewController) {
        detailsObject = object
        parent = parentVC
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return parent!.textFieldShouldBeginEditing(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let detail = textFields[textField] else {return false}
        let text = ((textField.text! as NSString).replacingCharacters(in: range, with: string))
        if detail.modify(detailsObject, with: text)  {
            parent!.objectChanged()
            return true
        }
        return false
    }
    
    func reset() {
        textFields.removeAll()
    }
    
    func add(textField: UITextField, edits detail: DetailType) {
        if let field = textFieldFor(detail) {
            textFields.remove(at: (textFields.index(forKey: field))!)
        }
        textFields[textField] = detail
        textField.delegate = self
    }
    
    func textFieldFor(_ detail: DetailType) -> UITextField? {
        for t in textFields.keys {
            if textFields[t] == detail {
                return t
            }
        }
        return nil
    }
    
    func keyboardNotification(notification: Notification) {
        if parent == nil {
            return
        }
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            /*if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
                } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }*/
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {self.parent?.view?.layoutIfNeeded()},
                           completion: nil)
        }
    }
}
