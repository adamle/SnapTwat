//
//  TwatViewVC.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 17/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import Firebase

class TwatViewVC: UIViewController {
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var twat = Twat(twatKey: "", fromEmail: "SnapTwatter", twatUrl: "", imageName: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailLabel.text = twat.fromEmail
        downloadTwat(url: twat.twatUrl, imageView: imageView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {
            DataService.instance.deleteTwat(ofUID: uid!, twat: twat, handler: { (success) in
                if success {
                    print("Success delete twat!")
                }
            })
            DataService.instance.decreaseDestroyCounter(forTwatImage: twat.imageName, handler: { (count) in
                let result = count
                if result == 0 {
                    DataService.instance.deleteImage(ofTwat: self.twat, handler: { (success) in
                        if success {
                        }
                    })
                    DataService.instance.deleteDestroyCounter(forTwatImage: self.twat.imageName, handler: { (success) in
                        if !success {
                            print("Error in deleteDestroyCounter")
                        }
                    })
                }
            })
        }
    }
    
    func downloadTwat(url: String, imageView: UIImageView) {
        let url = URL(string: url)
        let session = URLSession(configuration: .default)
        
        let getImage = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print("URL loading error: \(error)")
                return
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        let imageFromData = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            imageView.image = imageFromData
                        }
                    }
                    print("Success loading image")
                }
            }
        })
        getImage.resume()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}












