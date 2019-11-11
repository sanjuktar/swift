//
//  DetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/1/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class DetailsViewController<D:ObjectDetail,T:AnyObject>: UIViewController,
                             UITableViewDelegate, UITableViewDataSource,
                             UITextFieldDelegate, KeyboardHandler {
    @IBOutlet weak var tableView: UITableView!
    
    var object: T?
    var output: Output?
    var textFields: [UITextField:D] = [:]
    var editSaveButtonItem: UIBarButtonItem?
    var imagePicker: UIImagePickerController?
    var sections: [String] {
        fatalError("Must override!")
    }
    var handler: UIViewController? {
            return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
    }
    
    func details(in section: Int) -> [String] {
        fatalError("Must override!")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details(in: section).count
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlantDetail.nickname.genericCellHeight
    }
    
    func cell(_ indexPath: IndexPath) -> DetailsTableCell {
        fatalError("Must override!")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let detail = textFields[textField] else {return false}
        let text = ((textField.text! as NSString).replacingCharacters(in: range, with: string))
        if !detail.modify(object!, with: text) {
            return false
        }
        if detail.validate(object!) {
            editSaveButtonItem?.isEnabled = true
        }
        else {
            editSaveButtonItem?.isEnabled = false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func addToTextFields(_ textField: UITextField, dataItem: D) {
        if let field = textFieldFor(dataItem) {
            textFields.remove(at: textFields.index(forKey: field)!)
        }
        textFields[textField] = dataItem
        textField.delegate = self
    }
    
    private func textFieldFor(_ item: D) -> UITextField? {
        for t in textFields.keys {
            if let detail = textFields[t]  {
                return (detail == item ? t : nil)
            }
        }
        return nil
    }
}

