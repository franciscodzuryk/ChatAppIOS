//
//  User.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 14/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation

class User: Codable, Equatable {
    let id: Int?
    let name: String
    var msgsCount: Int
    var msgs = [Message]()
    
    init(id: Int, name: String, msgsCount: Int) {
        self.id = id
        self.name = name
        self.msgsCount = msgsCount
    }
    var userId: String {
        get {
            guard let id = self.id else {
                return ""
            }
            return String(id)
        }
    }
    
    var msgsCountStr: String {
        get {
            return String(msgsCount)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case msgsCount
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
