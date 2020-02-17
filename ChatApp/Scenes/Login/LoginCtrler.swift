//
//  LoginCtrler.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 29/01/2020.
//  Copyright © 2020 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation

class LoginCtrler {
    private weak var view: LoginViewInterface!
    private let apiUserClient: APIUserClientInterface
    private let apiCompanyClient: APICompanyClientInterface
    var loginAsCompany: Bool {
        didSet {
            LocalStorage.setLoggedAsCompany(loginAsCompany)
            view.selectLoginMode(loginAsCompany: loginAsCompany)
        }
    }
    
    init(_ view: LoginViewInterface, apiUserClient: APIUserClientInterface, apiCompanyClient: APICompanyClientInterface) {
        self.view = view
        self.apiUserClient = apiUserClient
        self.apiCompanyClient = apiCompanyClient
        self.loginAsCompany = LocalStorage.isLoggedAsCompany()
        view.selectLoginMode(loginAsCompany: loginAsCompany)
    }
    
    func login(name: String) {
        LocalStorage.setLoginName(name)
        if loginAsCompany {
            loginAsCompany(companyName: name)
        } else {
            loginAsUser(userName: name)
        }
    }
    
    private func loginAsCompany(companyName: String) {
        let company = Company(name: companyName, status: .active)
        apiCompanyClient.login(company: company, success: { [weak self] (company) in
            guard let self = self else {
                return
            }
            self.view.login(company: company)
        }) { (error) in
            self.view.networkError(error: error)
        }
    }
    
    private func loginAsUser(userName: String) {
        let user = User(id: 0, name: userName, msgsCount: 0)
        apiUserClient.login(user: user, success: { [weak self] (user) in
            guard let self = self else {
                return
            }
            self.view.login(user: user)
        }) { (error) in
            self.view.networkError(error: error)
        }
    }
}
