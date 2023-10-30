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
        content.text = entity.date.mediumDate
        content.secondaryText = entity.information
        content.image = imageCell(entity.isLocation)
        self.contentConfiguration = content
    }
    
    private func imageCell(_ isLocation: Bool) -> UIImage? {
        isLocation
        ?
        UIImage(systemName: "location.square", withConfiguration: nil)
        :
        UIImage(systemName: "doc", withConfiguration: nil)
    }

}
