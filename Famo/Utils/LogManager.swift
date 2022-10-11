//
//  LogManager.swift
//  Famo
//
//  Created by 엔나루 on 2022/10/08.
//

import Foundation
import FirebaseAnalytics

class LogManager {
    static var shared = LogManager()
    
    func appLeave() {
        let id = UserDefaults.standard.string(forKey: "id") ?? "guest"
        Analytics.logEvent("APP_LEAVE", parameters: ["userId":id])
    }
    
    func appEnter() {
        let id = UserDefaults.standard.string(forKey: "id") ?? "guest"
        Analytics.logEvent("APP_ENTER", parameters: ["userId":id])
    }
    
    func loginFailure(emailInput: String, passwordInput: String) {
        Analytics.logEvent("LOGIN_FAILURE",
                           parameters: [
                            "userId":emailInput,
                            "password":passwordInput
                           ])
    }
    
    func loginSuccess(emailInput: String) {
        Analytics.logEvent("LOGIN_SUCCESS", parameters: ["userId":emailInput])
    }
    
}
