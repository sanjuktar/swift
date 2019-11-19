//
//  ImagePickerController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/11/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

class ImagePickerController: NSObject, UIImagePickerControllerDelegate {
    var parent: DetailsViewController
    var imagePicker: UIImagePickerController {
        return UIImagePickerController()
    }
    
    init(_ parent: DetailsViewController) {
        self.parent = parent
    }
    
    func snapPicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            parent.present(imagePicker, animated: true, completion: nil)
        }
        else {
            parent.output?.output(.error, "Camera not available.")
        }
    }
    
    func didPickImage(_ imageView: UIImageView, _ imageInfo: [String : AnyObject]) {
        let image = imageInfo[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        parent.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.dismiss(animated: true, completion: nil)
    }
}

