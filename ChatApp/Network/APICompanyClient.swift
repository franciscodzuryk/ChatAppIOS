//
//  APICompanyClient.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 29/01/2020.
//  Copyright © 2020 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation
import Alamofire

protocol APICompanyClientInterface {
    func login(company: Company, success:@escaping (_ result: Company) -> Void, fail: @escaping (_ error: Error) -> Void)
    func logout(success:@escaping (_ result: Company) -> Void, fail: @escaping (_ error: Error) -> Void)
    func sendMessage(message: Message, user: User, success:@escaping (_ result: MessageStatusResponse) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getMessages(user: User, success:@escaping (_ result: [Message]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getAllMessages(success:@escaping (_ result: [CompanyMessages]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getStatus(success:@escaping (_ users: [User]) -> Void, fail: @escaping (_ error: Error) -> Void)
}

class APICompanyClient : APICompanyClientInterface {
    private let requestManager = RequestManager()
    
    func login(company: Company, success:@escaping (_ result: Company) -> Void, fail: @escaping (_ error: Error) -> Void) {
        guard let data = try? JSONEncoder().encode(company) else {
            fail(BaseURLError.POSTEmptyData)
            return
        }
        
        guard let request = requestManager.POSTRequest(path: "/company/login/", data: data) else {
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
    
    func logout(success:@escaping (_ result: Company) -> Void, fail: @escaping (_ error: Error) -> Void) {
        guard let request = requestManager.POSTRequest(path: "/company/logout/", data: nil) else {
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
    
    func sendMessage(message: Message, user: User, success:@escaping (_ result: MessageStatusResponse) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(message) else {
            fail(BaseURLError.POSTEmptyData)
            return
        }
        
        guard let request = requestManager.POSTRequest(path: "/user/\(user.userId)/message", data: data) else {
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
        guard let request = requestManager.GETRequest(path: "/company/message/user/\(user.userId)") else {
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
    
    func getAllMessages(success:@escaping (_ result: [CompanyMessages]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        guard let request = requestManager.GETRequest(path: "/company/message/") else {
            fail(BaseURLError.wrongURL)
            return
        }
        
        Alamofire.request(request).responseJSON { response in
            if response.result.isSuccess {
                guard let json = response.data, let result = try? JSONDecoder().decode([CompanyMessages].self, from: json) else {
                    fail(BaseURLError.wrongRespnose)
                    return
                }
                success(result)
            } else {
                fail(response.result.error ?? BaseURLError.serverFails)
            }
        }
    }
    
    func getStatus(success: @escaping ([User]) -> Void, fail: @escaping (Error) -> Void) {
        guard let request = requestManager.GETRequest(path: "/user/status") else {
            fail(BaseURLError.wrongURL)
            return
        }
        
        Alamofire.request(request).responseJSON { response in
            if response.result.isSuccess {
                guard let json = response.data, let result = try? JSONDecoder().decode([User].self, from: json) else {
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
