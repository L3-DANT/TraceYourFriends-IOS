//
//  Amis.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 12/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class Amis {
    var ami = [
        User(name:"Alban", category: "Friends",coorX:"76", coorY: "76"),
        User(name:"Aniss", category: "Friends",coorX:"76", coorY: "76"),
        User(name:"Kaci", category: "Request",coorX:"76", coorY: "76"),
        User(name:"Leila", category: "Request",coorX:"76", coorY: "76"),
        User(name:"Romann", category: "Favourite",coorX:"76", coorY: "76"),
        User(name:"Test", category: "Request",coorX:"76", coorY: "76"),
        ]
    static let getInstance = Amis()
    
    func userFromName(name :String) -> User?{
        for user in ami {
            if(user.name == name){
                return user
            }
        }
        return nil
    }
}
