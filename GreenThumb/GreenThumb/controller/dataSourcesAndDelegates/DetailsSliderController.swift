//
//  SliderController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/19/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class DetailsSliderController<DetailType:ObjectDetail>: NSObject, SliderDelegate {
    var parent: EditableTableViewController?
    var object: DetailType.ObjectType?
    var details: [UISlider:DetailType] = [:]
    
    init(_ obj: DetailType.ObjectType, _ parent: EditableTableViewController) {
        self.parent = parent
        object = obj
    }
    
    func reset() {
        details.removeAll()
    }
    
    func add(slider: UISlider, edits detail: DetailType) {
        for pair in details {
            if pair.value == detail {
                details.remove(at: details.index(forKey: pair.key)!)
            }
        }
        details[slider] = detail
    }
}
