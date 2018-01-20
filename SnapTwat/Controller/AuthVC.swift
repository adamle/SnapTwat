//
//  AuthVC.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 16/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var smileAnim: UILabel!
    @IBOutlet weak var straightAnim: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeAnimToStraight()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return}
        presentDetail(loginVC)
        changeAnimToStraight()
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        guard let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC else { return}
        presentDetail(registerVC)
        changeAnimToStraight()
    }
    
    @IBAction func loginTouchDown(_ sender: Any) {
        changeAnimToSmile()
    }
    
    @IBAction func loginRelease(_ sender: Any) {
        changeAnimToStraight()
    }
    
    @IBAction func registerTouchDown(_ sender: Any) {
        changeAnimToSmile()
    }
    
    @IBAction func registerRelease(_ sender: Any) {
        changeAnimToStraight()
    }
    
    func changeAnimToSmile() {
        smileAnim.isHidden = false
        straightAnim.isHidden = true
    }
    
    func changeAnimToStraight() {
        smileAnim.isHidden = true
        straightAnim.isHidden = false
    }
}
