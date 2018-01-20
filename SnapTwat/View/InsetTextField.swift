//
//  InsetTextField.swift
//  Learning from Devslopes Tutorial
//
//  Created by Le Dang Dai Duong on 12/10/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
    
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5115654364, green: 0.5133635601, blue: 0.5187579315, alpha: 1)])
        self.attributedPlaceholder = placeholder
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.5115654364, green: 0.5133635601, blue: 0.5187579315, alpha: 1)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // Take a rect, inset it to return another rect
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
