//
//  User.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 12/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import Foundation

class User {
    var name : String
    var category : String
    var coorX : Double
    var coorY : Double
    
    init(name: String, category: String, coorX: Double, coorY : Double){
        self.name = name
        self.category = category
        self.coorX = coorX
        self.coorY = coorY
    }
}