//
//  KeyboardHandler.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/29/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol KeyboardHandler {
    var handler: UIViewController? {get}
}

extension KeyboardHandler {
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: handler?.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        handler?.view.addGestureRecognizer(tap)
        /*NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)*/
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { (note) in
            self.keyboardNotification(notification: note)
        }
    }
    
    func keyboardNotification(notification: Notification) {
        if handler == nil {
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
                           animations: {self.handler?.view?.layoutIfNeeded()},
                           completion: nil)
        }
    }
}
