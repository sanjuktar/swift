//
//  EditValueViewController.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

enum EditType {
    case textEdit(name: String, current: String, type: TextType, detail: String)
    case optionsTable(options: [MeasurementUnit], selected: Int)
}

enum IgnoreStatus: Equatable {
    case ignore(Bool)
    case cannotIgnore
    
    static var ignored: String {
        return "ignore"
    }
}

protocol EditValueController {
    func setValueIgnored(_ flag: Bool)
}

class EditValueChildViewController : UIViewController, EditValueController {
    func setValueIgnored(_ flag: Bool) {
        return
    }
}

class EditValueViewController: UIViewController {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var ignoreLabel: UILabel!
    
    @IBAction func ignoreButtonClicked(_ sender: Any) {
        guard case .ignore(let flag) = ignoreStatus else {return}
        ignoreStatus = .ignore(!flag)
        setupForIgnoreStatus()
        saveButton.isEnabled = true
    }
    
    static var checked: UIImage = UIImage(imageLiteralResourceName: "checkbox_checked")
    static var unchecked: UIImage = UIImage(imageLiteralResourceName: "checkbox_empty")
    var currentChildVC: EditValueChildViewController?
    var valueName: String?
    var editType: EditType = .textEdit(name: "", current: "", type: TextType(.string), detail: "")
    var ignoreStatus: IgnoreStatus = .cannotIgnore
    
    lazy var textEditVC :TextEditViewController = getTextEditVC(editType)
    lazy var optionsTableVC :OptionsTableViewController = getOptionsTableVC(editType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch editType {
        case .textEdit(name: _, current: _, type: _, detail: _):
            setCurrentVC(textEditVC)
        case .optionsTable(options: _, selected: _):
            setCurrentVC(optionsTableVC)
        }
        headingLabel.text = valueName
        headingLabel.sizeToFit()
        setupForIgnoreStatus()
        saveButton.isEnabled = false
    }
    
    func save() {
        switch editType {
        case .optionsTable(let options, _):
            editType = .optionsTable(options: options, selected: optionsTableVC.selected!)
        case .textEdit(let name, _, let type, let unit):
            editType = .textEdit(name: name, current: textEditVC.textField.text!, type: type, detail: unit)
        }
    }
    
    func getTextEditVC(_ details: EditType) -> TextEditViewController {
        let storyboard = UIStoryboard(name: "DataEdit", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "textEditController") as! TextEditViewController
        if case .textEdit(let name, let current, let type, let detail) = editType {
            vc.name = name
            vc.text = current
            vc.textType = type
            vc.detail = detail
        }
        return vc
    }
    
    func getOptionsTableVC(_ details: EditType) -> OptionsTableViewController {
        let storyboard = UIStoryboard(name: "DataEdit", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "optionsTableController") as! OptionsTableViewController
        if case .optionsTable(let options, let selected) = editType {
            vc.options = options.map{$0.name}
            vc.selected = selected
        }
        vc.maxHeight = containerView.bounds.height
        return vc
    }
    
    func setCurrentVC(_ vc: EditValueChildViewController) {
        if currentChildVC != nil {
            removeCurrentVC()
        }
        addChildViewController(vc)
        containerView.addSubview(vc.view)
        vc.view.frame = containerView.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParentViewController: self)
        currentChildVC = vc
    }
    
    func removeCurrentVC() {
        currentChildVC?.willMove(toParentViewController: nil)
        currentChildVC?.view.removeFromSuperview()
        currentChildVC?.removeFromParentViewController()
        currentChildVC = nil
    }
    
    func setupForIgnoreStatus() {
        switch ignoreStatus {
        case .cannotIgnore:
            ignoreButton.isHidden = true
            ignoreLabel.isHidden = true
            currentChildVC?.setValueIgnored(false)
        case .ignore(true):
            ignoreButton.setImage(EditValueViewController.checked, for: .normal)
            ignoreStatus = .ignore(true)
            currentChildVC?.setValueIgnored(true)
        case .ignore(false):
            ignoreButton.setImage(EditValueViewController.unchecked, for: .normal)
            ignoreStatus = .ignore(false)
            currentChildVC?.setValueIgnored(false)
        }
    }
}
