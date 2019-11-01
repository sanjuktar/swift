//
//  PlantDetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantDetailsViewController: UIViewController {
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationValueView: UIView!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    //@IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBAction func unwindToPlantDetails(segue: UIStoryboardSegue) {
        if let source = segue.source as? LocationListPopoverViewController {
            let loc = source.location!.id
            plant?.location = loc
            for item in textFields {
                if item.value == .location {
                    item.key.text =  Location.manager!.get(loc)!.name
                    if validate() {
                        editSaveButton.isEnabled = true
                    }
                }
            }
            return
        }
    }
    
    static var detailTextFont = UIFont(name: "detailText", size: 5)
    static var detailLabelFont = UIFont(name: "detailLabel", size: 5)
    static var detailLabelColor: UIColor = .gray
    static var returnToPlantListSegue = "unwindEditPlantToList"
    static var careDetailsSegue = "plantDetailsToCareSegue"
    
    var plant: Plant?
    var editMode: Bool = false
    var output: Output?
    var imagePicker: UIImagePickerController?
    var textFields: [UITextField:PlantDetail] = [:]
    var plantImageTableCell: ImageTableCell?
    var performSegue = true
    
    var name: String {
        return plant?.name ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        if !plant!.name.isEmpty {
            setupTitle(plant!.name)
        }
        setupDetailsTable()
        setupImagePicker()
        setEditMode(editMode)
        textFields.removeAll()
        if !editMode {
            editSaveButton.isEnabled = true
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == PlantDetailsViewController.returnToPlantListSegue {
            if !editMode {
                setEditMode(true)
                detailsTable.reloadData()
                return false
            }
        }
        if identifier == PlantDetailsViewController.careDetailsSegue {
            let retVal = performSegue
            performSegue = true
            return retVal
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PlantDetailsViewController.returnToPlantListSegue {
            if editMode {
                if !validate() {
                    plant = nil
                    return
                }
            }
        }
        if segue.identifier == PlantDetailsViewController.careDetailsSegue {
            let dest = segue.destination as! CareDetailsViewController
            dest.care = plant?.care
        }
    }
    
    private func validate() -> Bool {
        for section in PlantDetail.Section.cases {
            for item in PlantDetail.items[section]! {
                if !validate(item) {
                    return false
                }
            }
        }
        return true
    }
    
    private func validate(_ item: PlantDetail) -> Bool {
        switch item {
        case .ignore:
            fatalError("Invalid detail!!!")
        case .image:
            return true
        case .location:
            return Location.manager?.get(plant!.location) != nil
        case .nickname:
            return plant!.names.validate()
        case .commonName:
            return plant!.names.validate()
        case .scientificName:
            return plant!.names.validate()
        case .water:
            return true
        case .light:
            return true
        case .fertilize:
            return true
        case .pestControl:
            return true
        case .prune:
            return true
        case .repot:
            return true
        }
    }
    
    private func setEditMode(_ flag: Bool) {
        editMode = flag
        if flag {
            editSaveButton.title = "Save"
        }
        else {
            editSaveButton.title = "Edit"
        }
        editSaveButton.isEnabled = validate()
        if plantImageTableCell != nil {
            plantImageTableCell?.cameraButton.isHidden = !editMode
        }
    }
    
    private func setupTitle(_ name: String) {
        self.title = name
    }
    
    private func showLocationPopup(_ sender: UIView) {
        let controller =  self.storyboard!.instantiateViewController(
            withIdentifier: "locationListPopoverViewController")
        (controller as! LocationListPopoverViewController).location = Location.manager!.get(plant!.location)
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sender
        presentationController.sourceRect = sender.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
}

extension PlantDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PlantDetail.Section.nSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (0..<PlantDetail.Section.nSections).contains(section) else {return 0}
        return (PlantDetail.items[PlantDetail.Section.cases[section]]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PlantDetail.Section.cases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataItem(at: indexPath)
        if case .image = item {
            let cell = detailsTable.dequeueReusableCell(withIdentifier: "imageTableCell") as! ImageTableCell
            cell.cameraButton.isHidden = !editMode
            plantImageTableCell = cell
            return cell
        }
        let label = "\(item.rawValue): "
        if editMode && !item.isCare {
            let cell = editModeCell(label, item)
            addToTextFields(cell.detailTextField, dataItem: item)
            return cell
        }
        let cell = viewModeCell(label, item.data(for: plant!))
        if item.isCare {
            cell.accessoryType = .disclosureIndicator
        }
        else {
            performSegue = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataItem(at: indexPath) == PlantDetail.image {
            return 175
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    private func setupDetailsTable() {
        detailsTable.delegate = self
        detailsTable.dataSource = self
    }
    
    private func editModeCell(_ label: String, _ item: PlantDetail) -> EditPlantTextCell {
        let cell = detailsTable.dequeueReusableCell(withIdentifier: "editPlantTextCell") as! EditPlantTextCell
        cell.titleLabel.text = label
        cell.titleLabel.font = PlantDetailsViewController.detailLabelFont
        cell.titleLabel.textColor = PlantDetailsViewController.detailLabelColor
        cell.titleLabel.sizeToFit()
        cell.detailTextField.text = item.data(for: plant!)
        cell.detailTextField.font = PlantDetailsViewController.detailTextFont
        cell.detailTextField.delegate = self
        return cell
    }
    
    private func viewModeCell(_ label: String, _ detail: String) -> UITableViewCell {
        let cell = detailsTable.dequeueReusableCell(withIdentifier: "plantTextCell")
        cell?.textLabel?.text = label
        cell?.textLabel?.textColor = PlantDetailsViewController.detailLabelColor
        cell?.detailTextLabel?.text = detail
        return cell!
    }
    
    private func indexPath(_ item: PlantDetail) -> IndexPath? {
        let section = item.section
        return IndexPath(row: (PlantDetail.items[section]?.firstIndex(of: item))!,
                         section: PlantDetail.Section.cases.firstIndex(of: section)!)
        
    }
    
    private func dataItem(at: IndexPath) -> PlantDetail {
        let section = PlantDetail.Section.cases[at.section]
        return PlantDetail.items[section]![at.row]
    }
}

extension PlantDetailsViewController: UITextFieldDelegate, KeyboardHandler {
    var handler: UIViewController? {
        get {
            return self
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let detail = textFields[textField]
        let text = ((textField.text! as NSString).replacingCharacters(in: range, with: string))
        switch detail {
        case .nickname: plant?.names.nickname = text
        case .commonName: plant?.names.common = text
        case .scientificName: plant?.names.scientific = text
        default: break
        }
        if validate(detail!) {
            editSaveButton.isEnabled = true
            if detail!.isName {
                setupTitle(name)
            }
        }
        else {
            editSaveButton.isEnabled = false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFields[textField] == PlantDetail.location {
            showLocationPopup(textField)
            return false
        }
        if textFields[textField]?.section == PlantDetail.Section.care {
            performSegue = true
            return false
        }
        performSegue = false
        return true
    }
    
    private func addToTextFields(_ textField: UITextField, dataItem: PlantDetail) {
        if let field = textFieldFor(dataItem) {
            textFields.remove(at: textFields.index(forKey: field)!)
        }
        textFields[textField] = dataItem
    }
    
    private func textFieldFor(_ item: PlantDetail) -> UITextField? {
        for t in textFields.keys {
            if textFields[t] == item {
                return t
            }
        }
        return nil
    }
}

extension PlantDetailsViewController: UIImagePickerControllerDelegate {
    @IBAction func takePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker?.allowsEditing = false
            imagePicker?.sourceType = UIImagePickerController.SourceType.camera
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
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        plantImageTableCell?.imgView.contentMode = .scaleAspectFit
        plantImageTableCell?.imgView.image = image
        dismiss(animated:true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
