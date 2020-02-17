//
//  APIClient.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 14/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation
import Alamofire

protocol APIUserClientInterface {
    func login(user: User, success:@escaping (_ result: User) -> Void, fail: @escaping (_ error: Error) -> Void)
    func logout(user: User, success:@escaping (_ result: User) -> Void, fail: @escaping (_ error: Error) -> Void)
    func sendMessage(message: Message, success:@escaping (_ result: MessageStatusResponse) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getMessages(user: User, success:@escaping (_ result: [Message]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getStatus(success:@escaping (_ result: Company) -> Void, fail: @escaping (_ error: Error) -> Void)
}

class APIUserClient : APIUserClientInterface {
    private let requestManager = RequestManager()
    
    func login(user: User, success:@escaping (_ result: User) -> Void, fail: @escaping (_ error: Error) -> Void) {
        
        guard let data = try? JSONEncoder().encode(user) else {
            fail(BaseURLError.POSTEmptyData)
            return
        }
        
        guard let request = requestManager.POSTRequest(path: "/user/login/", data: data) else {
            fail(BaseURLError.wrongURL)
            return
        }

        Alamofire.request(request).responseJSON { response in
            if response.result.isSuccess {
                guard let json = response.data, let result = try? JSONDecoder().decode(User.self, from: json) else {
                    fail(BaseURLError.wrongRespnose)
                    return
                }
                success(result)
            } else {
                fail(response.result.error ?? BaseURLError.serverFails)
            }
        }
    }
    
    func logout(user: User, success:@escaping (_ result: User) -> Void, fail: @escaping (_ error: Error) -> Void) {
        
        guard let request = requestManager.POSTRequest(path: "/user/\(user.userId)/logout/", data: nil) else {
            fail(BaseURLError.wrongURL)
            return
        }
        
        Alamofire.request(request).responseJSON { response in
            if response.result.isSuccess {
                guard let json = response.data, let result = try? JSONDecoder().decode(User.self, from: json) else {
                    fail(BaseURLError.wrongRespnose)
                    return
                }
                success(result)
            } else {
                fail(response.result.error ?? BaseURLError.serverFails)
            }
        }
    }
    
    func sendMessage(message: Message, success:@escaping (_ result: MessageStatusResponse) -> Void, fail: @escaping (_ error: Error) -> Void) {
        guard let data = try? JSONEncoder().encode(message) else {
            fail(BaseURLError.POSTEmptyData)
            return
        }
        
        guard let request = requestManager.POSTRequest(path: "/company/message", data: data) else {
            fail(BaseURLError.wrongURL)
            return
        }
        
        Alamofire.request(request).responseJSON { response in
            if response.result.isSuccess {
                guard let json = response.data, let result = try? JSONDecoder().decode(MessageStatusResponse.self, from: json) else {
                    fail(BaseURLError.wrongRespnose)
                    return
                }
                success(result)
            } else {
                fail(response.result.error ?? BaseURLError.serverFails)
            }
        }
    }
    
    func getMessages(user: User, success:@escaping (_ result: [Message]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        guard let request = requestManager.GETRequest(path: "/user/\(user.userId)/message") else {
            fail(BaseURLError.wrongURL)
            return
        }

        Alamofire.request(request).responseJSON { response in
            if response.result.isSuccess {
                guard let json = response.data, let result = try? JSONDecoder().decode([Message].self, from: json) else {
                    fail(BaseURLError.wrongRespnose)
                    return
                }
                success(result)
            } else {
                fail(response.result.error ?? BaseURLError.serverFails)
            }
        }
    }
    
    func getStatus(success: @escaping (Company) -> Void, fail: @escaping (Error) -> Void) {
        guard let request = requestManager.GETRequest(path: "/company/status") else {
            fail(BaseURLError.wrongURL)
            return
        }
        
        Alamofire.request(request).responseJSON { response in
            if response.result.isSuccess {
                guard let json = response.data, let result = try? JSONDecoder().decode(Company.self, from: json) else {
                    fail(BaseURLError.wrongRespnose)
                    return
                }
                success(result)
            } else {
                fail(response.result.error ?? BaseURLError.serverFails)
            }
        }
    }
}
