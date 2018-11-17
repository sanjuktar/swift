//
//  MessageWindow.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/12/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import os
import UIKit

class MessageWindow : Output {
    var types: OutputTypeList
    var parent: UIViewController
    
    init(_ parent: UIViewController, _ logTypes: OutputTypeList = OutputTypeList()) {
        types = logTypes
        self.parent = parent
    }
    
    func showMessage(_ message: String, _ title: String = "") {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .cancel))
        parent.present(vc, animated: false)
    }
    
    func out(_ type: OutputType, _ message: String) {
        switch OutputType(type.rawValue) {
        case .info: showMessage(message)
        case .debug: showMessage(message, "Debug")
        case .error: showMessage(message, "ERROR!")
        case .fault: showMessage(message, "FATAL ERROR!")
        default: showMessage(message, "Unknown output type")
        }
    }
}
