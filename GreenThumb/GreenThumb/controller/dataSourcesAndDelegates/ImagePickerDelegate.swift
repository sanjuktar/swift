//
//  ImagePickerDelegate.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate: UIImagePickerControllerDelegate {
    var imagePicker: UIImagePickerController? {get}
    var imgPickerDelegate: PlantDetailsViewController? {get}
}

extension ImagePickerDelegate {
    func snapPicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker?.allowsEditing = false
            imagePicker?.sourceType = UIImagePickerController.SourceType.camera
            imagePicker?.cameraCaptureMode = .photo
            imagePicker?.modalPresentationStyle = .fullScreen
            imgPickerDelegate?.present(imagePicker!, animated: true, completion: nil)
        }
        else {
            imgPickerDelegate?.output?.output(.error, "Camera not available.")
        }
    }
    
    func didPickImage(_ imageView: UIImageView, _ imageInfo: [String : AnyObject]) {
        let image = imageInfo[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imgPickerDelegate?.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imgPickerDelegate?.dismiss(animated: true, completion: nil)
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
