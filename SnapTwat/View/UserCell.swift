//
//  UserCell.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 19/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var tickIconImage: UIImageView!
    
    var checkMarkShown = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(email: String, isSelected: Bool) {
        self.userEmailLabel.text = email
        if isSelected {
            tickIconImage.isHidden = false
        } else {
            tickIconImage.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if checkMarkShown == false {
                tickIconImage.isHidden = false
                checkMarkShown = true
            } else {
                tickIconImage.isHidden = true
                checkMarkShown = false
            }
        }
    }

}
