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
        User(name:"Alban", category: "Friends",coorX:48.843293, coorY: 2.283060),
        User(name:"Aniss", category: "Friends",coorX: 48.996148, coorY: 1.686047),
        User(name:"Kaci", category: "Request",coorX: 48.928212, coorY: 2.386411),
        User(name:"Leila", category: "Request",coorX: 48.910410, coorY: 2.280922),
        User(name:"Romann", category: "Favorite",coorX:48.995689, coorY: 1.900270),
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
