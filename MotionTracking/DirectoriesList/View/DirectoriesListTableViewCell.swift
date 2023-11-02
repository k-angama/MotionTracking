//
//  DirectoriesListTableViewCell.swift
//  MotionTracking
//
//  Created by Karim Angama on 01/11/2023.
//

import UIKit

class DirectoriesListTableViewCell: UITableViewCell {
    
    func configuration(entity: String) {
        var content = self.defaultContentConfiguration()
        content.text = entity
        content.image = UIImage(systemName: "folder", withConfiguration: nil)
        self.contentConfiguration = content
    }

}
