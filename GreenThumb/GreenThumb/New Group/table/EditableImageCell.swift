//  GreenThumb
//
//  Created by Sanjukta Roy on 11/1/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class EditableImageCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    static func get(_ controller: EditableTableViewController, _ image: UIImage? = nil, _ editMode: Bool = false) -> EditableImageCell {
        controller.table?.register(UINib(nibName: "EditableImageCell", bundle: nil), forCellReuseIdentifier: ReuseId.editableImageCell)
        let cell = controller.table?.dequeueReusableCell(withIdentifier: ReuseId.editableImageCell) as! EditableImageCell
        cell.backgroundColor = DetailsConstants.Table.Cell.Color.background
        cell.cameraButton.isHidden = !editMode
        cell.imgView.image = image != nil ? image : UIImage.noImage()
        return cell
    }
}
