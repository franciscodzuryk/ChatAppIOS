//
//  LocalStorage.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 24/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation

class LocalStorage {
    private static let sharedUserDefaultsGroup = "group.chatapp.userDefaults"
    
    static func setDemoMode(_ demoMode: Bool) {
        guard let defaults = UserDefaults(suiteName: LocalStorage.sharedUserDefaultsGroup) else {
            return
        }
        defaults.setValue(demoMode, forKey: "DemoMode")
        defaults.synchronize()
    }
    
    static func isDemoMode() -> Bool {
        guard let defaults = UserDefaults(suiteName: LocalStorage.sharedUserDefaultsGroup) else {
            return false
        }
        return defaults.bool(forKey: "DemoMode")
    }
    
    static func setLoggedAsCompany(_ loggedAsCompany: Bool) {
        guard let defaults = UserDefaults(suiteName: LocalStorage.sharedUserDefaultsGroup) else {
            return
        }
        defaults.setValue(loggedAsCompany, forKey: "LoggedAsCompany")
        defaults.synchronize()
    }
    
    static func isLoggedAsCompany() -> Bool {
        guard let defaults = UserDefaults(suiteName: LocalStorage.sharedUserDefaultsGroup) else {
            return false
        }
        return defaults.bool(forKey: "LoggedAsCompany")
    }
    
    static func setUser(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "User")
        UserDefaults.standard.synchronize()
    }
    
    static func getUser() -> User? {
        guard let data = UserDefaults.standard.object(forKey: "User") as? Data,
            let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    static func setLoginName(_ name: String) {
        guard let defaults = UserDefaults(suiteName: LocalStorage.sharedUserDefaultsGroup) else {
            return
        }
        defaults.setValue(name, forKey: "LoginName")
        defaults.synchronize()
    }
    
    static func getLoginName() -> String {
        guard let defaults = UserDefaults(suiteName: LocalStorage.sharedUserDefaultsGroup) else {
            return ""
        }
        return defaults.string(forKey: "LoginName") ?? ""
    }
}
