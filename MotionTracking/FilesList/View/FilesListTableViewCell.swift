//
//  FilesListTableViewCell.swift
//  MotionTracking
//
//  Created by Karim Angama on 04/02/2022.
//

import Foundation
import UIKit

class FilesListTableViewCell:UITableViewCell {
    
    func configuration(entity: FileTrackingEntity) {
        var content = self.defaultContentConfiguration()
        content.text = entity.name
        content.secondaryText = entity.date.mediumDate
        content.image = UIImage(systemName: "doc", withConfiguration: nil)
        self.contentConfiguration = content
    }

}
