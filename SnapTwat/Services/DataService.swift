//
//  DataService.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 17/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let SR_BASE = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    public private(set) var REF_DATABASE = DB_BASE
    public private(set) var REF_USERS = DB_BASE.child("users")
    public private(set) var REF_DESTROYCOUNTER = DB_BASE.child("destroyCounter")
    
    public private(set) var REF_STORAGE = SR_BASE
    public private(set) var REF_TWATIMAGE = SR_BASE.child("twatImages")
    
    func createUser(forUID uid: String, withData userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadImageDataToFirebase(image: UIImage, handler: @escaping(_ imageUrlString: String, _ imageName: String) -> ()) {
        if let uploadImageData = UIImageJPEGRepresentation(image, 0.1) {
            let imageName = "\(NSUUID().uuidString).jpeg"
            REF_TWATIMAGE.child(imageName).putData(uploadImageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Error in uploadImageDataToFirebase")
                    return
                } else {
                    if let imageUrlString = metadata?.downloadURL()?.absoluteString {
                        handler(imageUrlString, imageName)
                    }
                }
            })
        }
    }
    
    func getAllEmails(handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            
            handler(emailArray)
        }
    }
 
    func sendTwatToUser(withUID uid: String, fromEmail: String, twatUrl: String, imageName: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("Twats").childByAutoId().updateChildValues([
            "from": fromEmail,
            "twatUrl": twatUrl,
            "imageName": imageName
            ])
        sendComplete(true)
    }
    
    func getUid(forEmail email: String, handler: @escaping (_ uid: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for user in userSnapshot {
                let emailSnapshot = user.childSnapshot(forPath: "email").value as! String
                if emailSnapshot == email {
                    handler(user.key)
                }
            }
        }
    }
    
    func getTwatsForUser(withUID uid: String, handler: @escaping (_ twats: [Twat]) -> ()) {
        var twatArray = [Twat]()
        
        REF_USERS.child(uid).child("Twats").observeSingleEvent(of: .value) { (twatSnapshot) in
            guard let twatSnapshot = twatSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for twatSnap in twatSnapshot {
                let twatKey = twatSnap.key
                let email = twatSnap.childSnapshot(forPath: "from").value as! String
                let twatUrl = twatSnap.childSnapshot(forPath: "twatUrl").value as! String
                let imageName = twatSnap.childSnapshot(forPath: "imageName").value as! String
                let twat = Twat(twatKey: twatKey, fromEmail: email, twatUrl: twatUrl, imageName: imageName)
                twatArray.append(twat)
            }
            
            handler(twatArray)
        }
    }
    
    func deleteTwat(ofUID uid: String, twat: Twat, handler: @escaping (_ success: Bool) -> ()) {
        REF_USERS.child(uid).child("Twats").child(twat.twatKey).removeValue()
    }
    
    func deleteImage(ofTwat twat: Twat, handler: @escaping (_ success: Bool) -> ()) {
        REF_TWATIMAGE.child(twat.imageName).delete(completion: nil)
    }
    
    func setDestroyCounter(forTwatImage imageName: String, count: Int, completion: @escaping(_ status: Bool) -> ()) {
        REF_DESTROYCOUNTER.childByAutoId().updateChildValues(["imageName": imageName, "count" : count])
        completion(true)
    }
    
    func decreaseDestroyCounter(forTwatImage imageName: String, handler: @escaping (_ result: Int) -> ()) {
        REF_DESTROYCOUNTER.observeSingleEvent(of: .value) { (counterSnapshot) in
            guard let counterSnapshot = counterSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for counter in counterSnapshot {
                let imageNameSnapshot = counter.childSnapshot(forPath: "imageName").value as! String
                if imageNameSnapshot == imageName {
                    let count = counter.childSnapshot(forPath: "count").value as! Int
                    let result = count - 1
                    self.REF_DESTROYCOUNTER.child(counter.key).updateChildValues(["count": result])
                    handler(result)
                    return
                }
            }
        }
    }
    
    func deleteDestroyCounter(forTwatImage imageName: String, handler: @escaping (_ success: Bool) -> ()) {
        REF_DESTROYCOUNTER.observeSingleEvent(of: .value) { (counterSnapshot) in
            guard let counterSnapshot = counterSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for counter in counterSnapshot {
                let imageNameSnapshot = counter.childSnapshot(forPath: "imageName").value as! String
                if imageNameSnapshot == imageName {
                    self.REF_DESTROYCOUNTER.child(counter.key).removeValue()
                    return
                }
            }
            
            handler(true)
        }
    }
}













