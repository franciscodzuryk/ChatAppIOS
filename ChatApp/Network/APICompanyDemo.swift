//
//  APICompanyDemo.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 29/01/2020.
//  Copyright © 2020 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation

class APICompanyDemo : APICompanyClientInterface {
    private static var messages = [Message]()
    
    func login(company: Company, success: @escaping (Company) -> Void, fail: @escaping (Error) -> Void) {
        success(Company(name: company.name, status: .active))
    }
    
    func logout(success: @escaping (Company) -> Void, fail: @escaping (Error) -> Void) {
        success(Company(name: "company.name", status: .inactive))
    }
    
    func sendMessage(message: Message, user: User, success: @escaping (MessageStatusResponse) -> Void, fail: @escaping (Error) -> Void) {
        if message.type == .sentMessage {
            APICompanyDemo.messages.append(Message(userId: 1, message: message.message, type: .recivedMessage, bill: nil))
        }
        success(MessageStatusResponse(status: .sent))
    }
    
    func getMessages(user: User, success: @escaping ([Message]) -> Void, fail: @escaping (Error) -> Void) {
        success(APICompanyDemo.messages)
        APICompanyDemo.messages.removeAll()
    }
    
    func getAllMessages(success:@escaping (_ result: [CompanyMessages]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        success([])
        APICompanyDemo.messages.removeAll()
    }
    
    func getStatus(success: @escaping ([User]) -> Void, fail: @escaping (Error) -> Void) {
        success([User(id: 0, name: "User One", msgsCount: APICompanyDemo.messages.count),
            User(id: 0, name: "User Two", msgsCount: APICompanyDemo.messages.count),
            User(id: 0, name: "User Three", msgsCount: APICompanyDemo.messages.count)])
    }
}
