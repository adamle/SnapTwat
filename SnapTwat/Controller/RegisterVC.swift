//
//  RegisterVC.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 17/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var emailTextField: InsetTextField!
    @IBOutlet weak var passwordTextField: InsetTextField!
    @IBOutlet weak var confirmPasswordTextField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        emailTextField.resignFirstResponder()
        if emailTextField.text != nil && passwordTextField.text != nil && confirmPasswordTextField.text != nil {
            if passwordTextField.text == confirmPasswordTextField.text {
                AuthService.instance.registerUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!, userCreationComplete: { (success, error) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailTextField.text!, andPassword: self.passwordTextField.text!, loginComplete: { (success, error) in
                            if success {
                                print("Success register user")
                                guard let twatListVC = self.storyboard?.instantiateViewController(withIdentifier: "TwatListVC") as? TwatListVC else { return}
                                self.present(twatListVC, animated: true, completion: nil)
                            }
                        })
                    } else {
                        self.showToast(message: "Oops I can't sign you up T.T")
                    }
                })
            } else {
                showToast(message: "Password mismatch")
            }
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        guard let authVC = storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC else { return}
        dismissDetail(authVC)
    }
    
    
}
