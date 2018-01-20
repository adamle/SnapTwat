//
//  TwatListVC.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 17/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import Firebase

class TwatListVC: UIViewController {
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    var twatArray = [Twat]()

    override func viewDidLoad() {

        super.viewDidLoad()
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // Display user email for welcome label
        let email = Auth.auth().currentUser?.email
        // Provide default value to prevent crash and Swift trying to add Optional("email")
        userEmailLabel.text = "Hello, \(email ?? "Snap Twatter")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get all twats for current user
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {
            DataService.instance.REF_USERS.child(uid!).child("Twats").observe(.childAdded) { (snapshot) in
                DataService.instance.getTwatsForUser(withUID: uid!) { (returnTwatArray) in
                    self.twatArray = returnTwatArray
                    self.tableView.reloadData()
                }
                DataService.instance.REF_USERS.child(uid!).child("Twats").observe(.childRemoved, with: { (snapshot) in
                    var index = 0
                    for twat in self.twatArray {
                        if snapshot.key == twat.twatKey {
                            self.twatArray.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
                print("Success logout user")
                print(Auth.auth().currentUser?.uid == nil)
            } catch {
                print(error)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(cancelAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    @IBAction func takeTwatPressed(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadFromPhotoLibrary(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension TwatListVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            guard let sendTwatVC = storyboard?.instantiateViewController(withIdentifier: "SendTwatVC") as? SendTwatVC else { return}
            sendTwatVC.uploadImage = image
            imagePicker.present(sendTwatVC, animated: true, completion: nil)
        }
        
    }
}

extension TwatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewTwatCell") as? NewTwatCell else { return UITableViewCell()}
        cell.configureCell(email: self.twatArray[indexPath.row].fromEmail)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewTwatCell else { return}
        cell.contentView.backgroundColor = #colorLiteral(red: 0.9381741751, green: 0.8473474616, blue: 0.1829718567, alpha: 1)
        
        guard let twatViewVC = storyboard?.instantiateViewController(withIdentifier: "TwatViewVC") as? TwatViewVC else { return}
        twatViewVC.twat = twatArray[indexPath.row]
        presentDetail(twatViewVC)
    }
}









