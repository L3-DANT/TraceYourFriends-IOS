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
    func deleteAll(tab : Array<String>, str: String) -> Array<User>{
        var listAno : Array<User> = []
        var bool : Bool = true
        var cpt : Int = 0
        var i : User
        var t : String
        if str == "Friends"{
            for i in ami {
                for t in tab {
                    if i.name == t {
                        bool = false
                    }
                }
                if bool {
                    listAno.append(i)
                    ami.removeAtIndex(cpt)
                }
                cpt += 1
            }
            return listAno
        }
        if str == "Request" {
            for i in request {
                for t in tab {
                    if i.name == t {
                        bool = false
                    }
                }
                if bool {
                    listAno.append(i)
                    request.removeAtIndex(cpt)
                }
                cpt += 1
            }
            return listAno
        }
        if str == "All" {
            ami = []
            request = []
        }
        return listAno
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
