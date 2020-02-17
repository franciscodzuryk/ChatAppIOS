//
//  APIDemo.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 18/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation

class APIUserDemo : APIUserClientInterface {
    private var messages = [Message]()
    
    func login(user: User, success:@escaping (_ result: User) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let userResult = User(id: 0, name: user.name, msgsCount: 0)
        success(userResult)
    }
    
    func logout(user: User, success:@escaping (_ result: User) -> Void, fail: @escaping (_ error: Error) -> Void) {
        success(user)
    }
    
    func sendMessage(message: Message, success:@escaping (_ result: MessageStatusResponse) -> Void, fail: @escaping (_ error: Error) -> Void) {
        if message.message.contains("bill") {
            self.messages.append(Message(userId: 1, message: "", type: .bill, bill: Bill(userId: 1, accountNumber: "12344567", price: 10.5, taxes: 2.5, dueDate: "10/12/2019", total: 12.5)))
        } else {
            self.messages.append(Message(userId: 1, message: message.message, type: .recivedMessage, bill: nil))
        }
    
        success(MessageStatusResponse(status: .sent))
    }
    
    func getMessages(user: User, success:@escaping (_ result: [Message]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        success(messages)
        self.messages.removeAll()
    }
    
    func getStatus(success: @escaping (Company) -> Void, fail: @escaping (Error) -> Void) {
        success(Company(name: "Company Name", status: .active))
    }
}
