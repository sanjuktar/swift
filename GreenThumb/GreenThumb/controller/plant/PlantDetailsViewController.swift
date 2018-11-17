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
    
    static var returnToPlantListSegue = "plantDetailsToListSegue"
    var plant: Plant?
    var output: Output?
    var imagePicker: UIImagePickerController?
    var editMode: Bool = false
    var validDetails: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        setEditMode(editMode)
        detailsTable.delegate = self
        detailsTable.dataSource = self
        imagePicker = UIImagePickerController()
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == PlantDetailsViewController.returnToPlantListSegue {
            if !editMode {
                setEditMode(true)
                detailsTable.reloadData()
                return false
            }
            return true
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
    
    func saveDetails() {
        guard validDetails else {plant = nil; return}
        let nameTypes = Plant.NameType.cases
        plant?.names = [:]
        for type in nameTypes {
            let cell = detailsTable.cellForRow(at: IndexPath(row: nameTypes.index(of: type)!, section: 0)) as! EditPlantTextCell
            plant?.names[type] = cell.textField.text
        }
    }
}

extension PlantDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var label, detail: String
        let type = Plant.NameType.cases[indexPath.row]
        label = type.rawValue
        detail = (plant?.names[type]) ?? ""
        return editMode ? editModeCell("\(label): ", detail) : viewModeCell(label, detail)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    private func editModeCell(_ label: String, _ detail: String) -> EditPlantTextCell {
        let cell = detailsTable.dequeueReusableCell(withIdentifier: "editPlantTextCell") as! EditPlantTextCell
        cell.label.text = label
        cell.label.sizeToFit()
        cell.textField.text = detail
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
