//
//  UserModel.swift
//  DAiOSAssignment
//
//  Created by VEER BAHADUR TIWARI on 16/07/18.
//  Copyright © 2018 docAnywhere. All rights reserved.
//

import UIKit


struct ResultModel : Codable {
    let status: Bool?
    let message: String?
    let userList: UserList?
    
    //Result  coding keys
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case userList = "data"
        
    }
}
struct UserModel: Codable {
    
    let name: String?
    let image: String?
    let items: [String]?
    
    //User coding keys
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case image = "image"
        case items = "items"
    }
}
struct UserList: Codable {
    
    let users: [UserModel]?
    let has_more: Bool?
    
}

