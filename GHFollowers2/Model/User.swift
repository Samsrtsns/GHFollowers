//
//  User.swift
//  GHFollowers2
//
//  Created by Samet KATI on 15.05.2024.
//

import Foundation

struct User : Codable{
    
    var login : String
    var avatarUrl : String
    var name : String?
    var location : String?
    var bip : String?
    var publicRepos : Int
    var publicGists : Int
    var htmlUrl : String
    var following : Int
    var followers : Int
    var createdAt : String
    
}
