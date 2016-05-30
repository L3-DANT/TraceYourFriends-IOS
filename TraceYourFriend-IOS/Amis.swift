//
//  Amis.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 12/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class Amis {
    var ami = [User]()
    var users = [
        /*User(name:"Adrien", category: "User",coorX:49.843293, coorY: 2.283060),
        User(name:"Olivier", category: "User",coorX: 47.996148, coorY: 1.686047),
        User(name:"Reda", category: "User",coorX: 50.928212, coorY: 2.386411),
        User(name:"Julien", category: "User",coorX: 46.910410, coorY: 2.280922),
        User(name:"Anne", category: "User",coorX:45.995689, coorY: 1.900270),*/
    ]
    var request = [User]()
    static let getInstance = Amis()
    
    func userFromName(name :String) -> User?{
        for user in ami {
            if(user.name == name){
                return user
            }
        }
        return nil
    }
    func deleteAll(str : String) {
        if (str == "Friends" || str == "All"){
            ami = []
        }
        if(str == "Request" || str == "All"){
            request = []
        }
    }
    func add(user: User, str: String) {
        if (str == "Friends"){
            ami.append(user)
        }
        if(str == "Request"){
            request.append(user)
        }
    }
}
