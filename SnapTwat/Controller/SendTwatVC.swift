//
//  SendTwatVC.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 17/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class SendTwatVC: UIViewController {
    
    @IBOutlet weak var twatImageView: UIImageView!
    var uploadImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twatImageView.image = uploadImage        
    }
    
    @IBAction func sendTwatPressed(_ sender: Any) {
        DataService.instance.uploadImageDataToFirebase(image: uploadImage) { (returnedUrlString, imageName) in
            guard let selectReceiverVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectReceiverVC") as? SelectReceiverVC else { return}
            selectReceiverVC.imageUrlString = returnedUrlString
            selectReceiverVC.imageName = imageName
            self.presentDetail(selectReceiverVC)
        }
    }
    
}
