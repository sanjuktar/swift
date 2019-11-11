//
//  ImagePickerController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/1/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

protocol ImagePickerDelegate: UIImagePickerControllerDelegate {
}

extension ImagePickerDelegate {
    func takePicture(_ parent: UIViewController, _ sender: Any, _ imagePicker: UIImagePickerController, _ output: Output) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            parent.present(imagePicker, animated: true, completion: nil)
        }
        else {
            output.output(.error, "Camera not available.")
        }
    }
    
    func imagePickerController(_ parent: UIViewController,
                                       _ picker: UIImagePickerController,
                                       _ imgView: UIImageView,
                                       didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        imgView.contentMode = .scaleAspectFit
        imgView.image = image
        parent.dismiss(animated:true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ parent: UIViewController, _ picker: UIImagePickerController) {
        parent.dismiss(animated: true, completion: nil)
    }
}
