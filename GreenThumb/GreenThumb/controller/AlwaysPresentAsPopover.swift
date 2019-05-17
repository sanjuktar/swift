//
//  AlwaysPresentAsPopover.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/12/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class AlwaysPresentAsPopover : NSObject, UIPopoverPresentationControllerDelegate {
    private static let sharedInstance = AlwaysPresentAsPopover()
    
    private override init() {
        super.init()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    static func configurePresentation(forController controller : UIViewController) -> UIPopoverPresentationController {
        controller.modalPresentationStyle = .popover
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        presentationController.delegate = AlwaysPresentAsPopover.sharedInstance
        return presentationController
    }
}
