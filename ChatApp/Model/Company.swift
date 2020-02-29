//
//  Company.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 18/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation

enum CompanyStatus: Int, Codable {
    case inactive = 0
    case active
    
    var description: String {
        switch self {
        case .active:
            return "Company Active"
        case .inactive:
            return "Company Inactive"
        }
    }
}

class Company: Codable {
    let name: String
    let status: CompanyStatus
    var users = [User]()
    
    private enum CodingKeys: String, CodingKey {
        case name
        case status
    }
    
    init(name: String, status: CompanyStatus) {
        self.name = name
        self.status = status
    }
    
    func addUsers(users: [User]) -> Bool {
        var added = false
        for user in users {
            if !self.users.contains(user) {
                added = true
                self.users.append(user)
            }
        }
        return added
    }
    
    func addMessages(msgsByUser: [CompanyMessages]) -> Bool{
        var added = false
        for user in msgsByUser {
            if let userToBeUpdateIndex = self.users.firstIndex(where: {$0.id == user.userId}) {
                added = true
                self.users[userToBeUpdateIndex].msgs.append(contentsOf: user.msgs)
                self.users[userToBeUpdateIndex].msgsCount = self.users[userToBeUpdateIndex].msgsCount + user.msgs.count
            }
        }
        return added
    }
}


class CompanyMessages : Codable {
    let userId: Int
    let msgs: [Message]
    
    private enum CodingKeys: String, CodingKey {
        case userId
        case msgs
    }
}
