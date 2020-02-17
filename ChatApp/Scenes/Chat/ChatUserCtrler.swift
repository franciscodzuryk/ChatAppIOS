//
//  ChatCtrler.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 17/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation

class ChatUserCtrler: ChatCtrler {
    private weak var view: ChatViewInterface!
    private let apiClient: APIUserClientInterface
    private var timer: DispatchSourceTimer?
    private var showNetworkError = true
    private var status = CompanyStatus.active
    var user: User
    
    init(_ view: ChatViewInterface, apiClient: APIUserClientInterface, user: User) {
        self.view = view
        self.apiClient = apiClient
        self.user = user
        self.user.msgsCount = 0
    }
    
    func startPolling() {
        let queue = DispatchQueue.global(qos: .background)
        timer = DispatchSource.makeTimerSource(queue: queue) as DispatchSourceTimer
        timer?.schedule(deadline: .now(), repeating: .seconds(2), leeway: .seconds(1))
        timer?.setEventHandler(handler: { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.showNetworkError {
                self.apiClient.getMessages(user: self.user, success: { (messages) in
                    if messages.count > 0 {
                        self.view.showMessages(messages: messages)
                    }
                }) { (error) in
                    self.view.networkError(error: error)
                    self.showNetworkError = false
                }
            }
            
            self.apiClient.getStatus(success: { (company) in
                self.view.showStatus(company: company)
                if self.status != company.status && company.status == .inactive {
                    self.status = company.status
                    self.view.askPlayVideo()
                }
            }, fail: { (error) in
                if self.showNetworkError {
                    self.view.networkError(error: error)
                    self.showNetworkError = false
                }
            })
        })
        timer?.resume()
    }
    
    func stopPolling() {
        timer?.cancel()
        timer = nil
    }
    
    func sendMessage(message: Message) {
        apiClient.sendMessage(message: message, success: { (status) in
            print("SENT: \(message.message)")
        }) { (error) in
            self.view.networkError(error: error)
        }
    }
}

