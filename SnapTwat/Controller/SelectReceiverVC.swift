//
//  SelectReceiverVC.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 19/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import Firebase

class SelectReceiverVC: UIViewController {

    var imageUrlString: String!
    var imageName: String!
    
    var emailArray = [String]()
    var chosenEmailArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.getAllEmails { (returnedEmailArray) in
            self.emailArray = returnedEmailArray
            self.tableView.reloadData()
        }
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        guard let twatListVC = storyboard?.instantiateViewController(withIdentifier: "TwatListVC") as? TwatListVC else { return}
        
        for email in chosenEmailArray {
            DataService.instance.getUid(forEmail: email, handler: { (uid) in
                DataService.instance.sendTwatToUser(withUID: uid, fromEmail: (Auth.auth().currentUser?.email)!, twatUrl: self.imageUrlString, imageName: self.imageName, sendComplete: { (success) in
                    if !success {
                        self.showToast(message: "Sorry, I'm unable to send Twat at the moment!")
                    }
                })
            })
        }

        DataService.instance.setDestroyCounter(forTwatImage: self.imageName, count: self.chosenEmailArray.count, completion: { (success) in
            if success {
                print("Success set destroy counter for twatImage: \(self.imageName)")
            }
        })
        
        self.present(twatListVC, animated: true, completion: nil)
    }
    
}

extension SelectReceiverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else { return UITableViewCell()}
        if chosenEmailArray.contains(cell.userEmailLabel.text!) {
            cell.configureCell(email: emailArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return}
        
        if !chosenEmailArray.contains(cell.userEmailLabel.text!) {
            chosenEmailArray.append(cell.userEmailLabel.text!)
        } else {
            chosenEmailArray = chosenEmailArray.filter({ $0 != cell.userEmailLabel.text! })
        }
        cell.contentView.backgroundColor = #colorLiteral(red: 0.9381741751, green: 0.8473474616, blue: 0.1829718567, alpha: 1)
    }
}















