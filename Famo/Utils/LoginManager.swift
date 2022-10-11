//
//  LoginManager.swift
//  Famo
//
//  Created by 엔나루 on 2022/10/08.
//

import Foundation
import FirebaseAuth

class LoginManager {
    
    func processLogin(email: String, password: String, completion: @escaping (Bool, Error?) -> Void ) {
        print("LoginManager: trying firebase Login")
        print("id: \(email)")
        //print("pw: \(password)")
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if authResult != nil {
                completion(true, nil)
            } else {
                print(error?.localizedDescription ?? "LoginManager: Login Failed")
                completion(false, error)
            }
        }
    }
    
    func processSignUp(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        print("LoginManager: trying firebase Signup")
        print("id: \(email)")
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if authResult != nil {
                completion(true, nil)
            } else {
                print(error?.localizedDescription ?? "LoginManager: Signup Failed")
                completion(false, error)
            }
        }
    }
}
