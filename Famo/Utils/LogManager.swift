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
        let uid = UserDefaults.standard.string(forKey: "UID") ?? "unknown"
        Analytics.logEvent("APP_LEAVE", parameters: ["UID":uid])
    }
    
    func appEnter() {
        let uid = UserDefaults.standard.string(forKey: "UID") ?? "unknown"
        Analytics.logEvent("APP_ENTER", parameters: ["UID":uid])
    }
    
    func loginFailure(emailInput: String, passwordInput: String) {
        Analytics.logEvent("LOGIN_FAILURE", parameters: [:])
    }
    
    func loginSuccess() {
        let uid = UserDefaults.standard.string(forKey: "UID") ?? "unknown"
        Analytics.logEvent("LOGIN_SUCCESS", parameters: ["UID":uid])
    }
    
    func signUpSuccess() {
        let uid = UserDefaults.standard.string(forKey: "UID") ?? "unknown"
        Analytics.logEvent("SIGNUP_SUCCESS", parameters: ["UID":uid])
    }
    
    func signUpFailure() {
        Analytics.logEvent("SIGNUP_FAILURE", parameters: [:])
    }
}
