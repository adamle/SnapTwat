//
//  LoginVC.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 17/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: InsetTextField!
    @IBOutlet weak var passwordTextField: InsetTextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        emailTextField.resignFirstResponder()
        if emailTextField.text != nil && passwordTextField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!, loginComplete: { (success, error) in
                if success {
                    print("Success login")
                    guard let twatListVC = self.storyboard?.instantiateViewController(withIdentifier: "TwatListVC") as? TwatListVC else { return}
                    self.self.presentDetail(twatListVC)
                } else {
                    self.showToast(message: "Ouch I can't log you in :-(")
                }
            })
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        guard let authVC = storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC else { return}
        dismissDetail(authVC)
    }
}
