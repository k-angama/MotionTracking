//
//  DirectoriesListTableViewCell.swift
//  MotionTracking
//
//  Created by Karim Angama on 01/11/2023.
//

import UIKit

class DirectoriesListTableViewCell: UITableViewCell {
    
    func configuration(entity: DirectoryEntity) {
        var content = self.defaultContentConfiguration()
        content.text = entity.name
        content.secondaryText = "\(entity.numberFile)"
        content.image = UIImage(systemName: "folder", withConfiguration: nil)
        self.contentConfiguration = content
    }

}
