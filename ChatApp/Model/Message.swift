//
//  Message.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 14/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation

enum MessageType: Int, Codable {
    case sentMessage = 0
    case recivedMessage
    case bill
}

struct Bill: Codable {
    let userId: Int
    let accountNumber: String
    let price: Double
    let taxes: Double
    let dueDate: String
    let total: Double
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case accountNumber
        case price
        case taxes
        case dueDate
        case total
    }
}

struct Message: Codable {
    let userId: Int
    let message: String
    let type: MessageType
    let bill: Bill?
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case message
        case type
        case bill
    }
}

enum MessageStatus: Int, Codable {
    case rejected = 0
    case sent
    case received
}

struct MessageStatusResponse: Codable {
    let status: MessageStatus
    
    private enum CodingKeys: String, CodingKey {
        case status
    }
}
