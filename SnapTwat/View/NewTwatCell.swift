//
//  NewTwatCell.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 19/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class NewTwatCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(email: String) {
        userEmailLabel.text = email
    }
}
