//
//  AuthService.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 17/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
 
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            // providerID can be Facebook, Google, Firebase, or email
            let userData = [
                "provider": user.providerID,
                "email": user.email
            ]
            DataService.instance.createUser(forUID: user.uid, withData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
    
}
