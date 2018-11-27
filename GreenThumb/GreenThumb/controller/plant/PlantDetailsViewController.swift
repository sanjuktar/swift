//
//  PlantDetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantDetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    static var returnToPlantListSegue = "plantDetailsToListSegue"
    var plant: Plant?
    var output: Output?
    var imagePicker: UIImagePickerController?
    var editMode: Bool = false
    var details: [PlantDataItem:String] = [:]
    var textFields: [UITextField: PlantDataItem] = [:]
    var validDetails: Bool {
        return Plant.NameType.nickname.isValid(details[PlantDataItem.nickname]) ||
               Plant.NameType.common.isValid(details[PlantDataItem.commonName]) ||
               Plant.NameType.scientific.isValid(details[PlantDataItem.scientificName])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        setEditMode(editMode)
        setupGestures()
        setupDetailsTable()
        setupImagePicker()
        for detail in PlantDataItem.cases {
            details[detail] = detail.data(for: plant!)
        }
        setEditMode(editMode)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == PlantDetailsViewController.returnToPlantListSegue {
            if !editMode {
                setEditMode(true)
                detailsTable.reloadData()
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PlantDetailsViewController.returnToPlantListSegue {
            if editMode {
                saveDetails()
            }
        }
    }
    
    func setEditMode(_ flag: Bool) {
        editMode = flag
        cameraButton.isHidden = !flag
        if flag {
            editSaveButton.title = "Save"
            navigationItem.title = "Edit Plant Details"
        }
        else {
            editSaveButton.title = "Edit"
            navigationItem.title = "Plant Details"
        }
    }
    
    func saveDetails() {
        guard validDetails else {plant = nil; return}
        plant?.names = [:]
        plant?.names[Plant.NameType.nickname] = details[PlantDataItem.nickname]
        plant?.names[Plant.NameType.common] = details[PlantDataItem.commonName]
        plant?.names[Plant.NameType.scientific] = details[PlantDataItem.scientificName]
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil)
    }
}

extension PlantDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? PlantDataItem.cases.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataItem = PlantDataItem.cases[indexPath.row]
        let label = "\(dataItem.rawValue): "
        let detail = details[dataItem]
        var cell: UITableViewCell
        if editMode {
            cell = editModeCell(label, detail!)
            for field in textFields {
                if field.value == PlantDataItem.cases[indexPath.row] {
                    textFields.removeValue(forKey: field.key)
                }
            }
            textFields[(cell as! EditPlantTextCell).textField] = dataItem
        }
        else {
            cell = viewModeCell(label, detail!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    private func setupDetailsTable() {
        detailsTable.delegate = self
        detailsTable.dataSource = self
    }
    
    private func editModeCell(_ label: String, _ detail: String) -> EditPlantTextCell {
        let cell = detailsTable.dequeueReusableCell(withIdentifier: "editPlantTextCell") as! EditPlantTextCell
        cell.label.text = label
        cell.label.sizeToFit()
        cell.textField.text = detail
        cell.textField.delegate = self
        return cell
    }
    
    private func viewModeCell(_ label: String, _ detail: String) -> PlantTextCell {
        let cell = detailsTable.dequeueReusableCell(withIdentifier: "plantTextCell") as! PlantTextCell
        cell.label.text = label
        cell.label.sizeToFit()
        cell.value.text = detail
        return cell
    }
}

extension PlantDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        details[textFields[textField]!] = ((text! as NSString).replacingCharacters(in: range, with: string))
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {        
        editSaveButton.isEnabled = validDetails ? true : false
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

extension PlantDetailsViewController: UIImagePickerControllerDelegate {
    @IBAction func takePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker?.allowsEditing = false
            imagePicker?.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker?.cameraCaptureMode = .photo
            imagePicker?.modalPresentationStyle = .fullScreen
            present(imagePicker!, animated: true, completion: nil)
        }
        else {
            output?.output(.error, "Camera not available.")
        }
    }
    
    private func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        dismiss(animated:true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
    }
}
