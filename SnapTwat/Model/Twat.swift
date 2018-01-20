//
//  Twat.swift
//  SnapTwat
//
//  Created by Le Dang Dai Duong on 19/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import Foundation

class Twat {

    public private(set) var twatKey: String
    public private(set) var fromEmail: String
    public private(set) var twatUrl: String
    public private(set) var imageName: String
    
    init(twatKey: String, fromEmail: String, twatUrl: String, imageName: String) {
        self.twatKey = twatKey
        self.fromEmail = fromEmail
        self.twatUrl = twatUrl
        self.imageName = imageName
    }
    
}
