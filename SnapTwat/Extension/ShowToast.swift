//
//  ShowToast.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 17/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit

extension UIViewController {
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        toastLabel.backgroundColor = #colorLiteral(red: 0.8836629391, green: 0.1792323589, blue: 0.6271354556, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Verdana", size: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 0;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.3
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
