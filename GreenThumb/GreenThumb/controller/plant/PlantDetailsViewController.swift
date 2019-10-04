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
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationValueView: UIView!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBAction func unwindToPlantDetails(segue: UIStoryboardSegue) {
        if let source = segue.source as? LocationListPopoverViewController {
            plant?.location = source.location!.id
            (locationValueSubview as! UITextField).text = source.location!.name
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
    var details: [PlantDetail:String] = [:]
    var imagePicker: UIImagePickerController?
    var textFields: [UITextField:PlantDetail] = [:]
    var locationValueSubview: UIView?
    var performSegue = true
    
    var name: String {
        var preferred: PlantDetail
        switch Plant.NameType.prefered {
        case Plant.NameType.nickname:
            preferred = .nickname
        case .common:
            preferred = .commonName
        case .scientific:
            preferred = .scientificName
        }
        if let n = details[preferred] {
            if !n.isEmpty {
                return n
            }
        }
        if !details[.nickname]!.isEmpty {
            return details[.nickname]!
        }
        if !details[.commonName]!.isEmpty {
            return details[.commonName]!
        }
        return details[.scientificName]!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        for items in PlantDetail.items.values {
            for item in items {
                details[item] = item.data(for: plant!)
            }
        }
        setupName()
        setupLocation()
        setupDetailsTable()
        setupGestures()
        setupImagePicker()
        setEditMode(editMode)
        textFields.removeAll()
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
                saveDetails()
            }
        }
        if segue.identifier == PlantDetailsViewController.careDetailsSegue {
            let dest = segue.destination as! CareDetailsViewController
            dest.care = plant?.care
        }
    }
    
    private func saveDetails() {
        plant?.names[Plant.NameType.nickname] = details[PlantDetail.nickname]
        plant?.names[Plant.NameType.common] = details[PlantDetail.commonName]
        plant?.names[Plant.NameType.scientific] = details[PlantDetail.scientificName]
    }
    
    private func validate() -> Bool {
        for item in PlantDetail.items[PlantDetail.Section.noSection]! {
            if !validate(item) {
                return false
            }
        }
        for section in PlantDetail.Section.cases {
            if section == PlantDetail.Section.names && !validateNames() {
                return false
            }
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
        case .location:
            return true
        case .nickname:
            return validateNames()
        case .commonName:
            return validateNames()
        case .scientificName:
            return validateNames()
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
    
    private func validateNames() -> Bool {
        return Plant.NameType.nickname.isValid(details[PlantDetail.nickname]) ||
            Plant.NameType.common.isValid(details[PlantDetail.commonName]) ||
            Plant.NameType.scientific.isValid(details[PlantDetail.scientificName])
    }
    
    private func setEditMode(_ flag: Bool) {
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
        editButtonItem.isEnabled = validate()
        setupName()
        setupLocation()
    }
    
    private func setupName() {
        nameLabel.font = PlantDetailsViewController.detailLabelFont
        nameLabel.textColor = PlantDetailsViewController.detailLabelColor
        nameValueLabel.text = plant?.name
        nameValueLabel.font = PlantDetailsViewController.detailTextFont
    }
    
    private func setupLocation() {
        locationLabel.font = PlantDetailsViewController.detailLabelFont
        locationLabel.textColor = PlantDetailsViewController.detailLabelColor
        let frame = CGRect(origin: locationValueView.frame.origin, size: CGSize(width: locationValueView.frame.width, height: 30))
        let location = Location.manager?.get(plant!.location)?.name
        if editMode {
            if locationValueSubview != nil {
                if locationValueSubview is UITextField {
                    (locationValueSubview as! UITextField).text = location
                    return
                }
                locationValueSubview?.removeFromSuperview()
            }
            let subview = UITextField(frame: frame)
            subview.text = location
            subview.font = PlantDetailsViewController.detailTextFont
            subview.clearsOnBeginEditing = true
            subview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(sender:))))
            locationValueSubview = subview
            addToTextFields(subview, dataItem: PlantDetail.location)
        }
        else {
            if locationValueSubview != nil {
                if locationValueSubview is UILabel {
                    (locationValueSubview as! UILabel).text = location
                    return
                }
                locationValueSubview?.gestureRecognizers?.remove(at: 0)
                locationValueSubview?.removeFromSuperview()
            }
            let subview = UILabel(frame: frame)
            subview.text = location
            subview.font = PlantDetailsViewController.detailTextFont
            locationValueSubview = subview
        }
        view.addSubview(locationValueSubview!)
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
    
    @objc private func didTap(sender: UITapGestureRecognizer) {
        if editMode {
            showLocationPopup(locationValueView)
        }
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
        let label = "\(item.rawValue): "
        if editMode && !item.isCare {
            let cell = editModeCell(label, item.data(for: plant!))
            addToTextFields(cell.detailTextField, dataItem: item)
            return cell
        }
        let cell = viewModeCell(label, item.data(for: plant!))
        if item.isCare {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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
        cell.titleLabel.text = label
        cell.titleLabel.font = PlantDetailsViewController.detailLabelFont
        cell.titleLabel.textColor = PlantDetailsViewController.detailLabelColor
        cell.titleLabel.sizeToFit()
        cell.detailTextField.text = detail
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
        if section == .noSection {
            return nil
        }
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
        details[detail!] = ((textField.text! as NSString).replacingCharacters(in: range, with: string))
        if validate(detail!) {
            editSaveButton.isEnabled = true
            if detail!.isName {
                nameLabel.text = name
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
