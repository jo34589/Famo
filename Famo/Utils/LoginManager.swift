//
//  LoginManager.swift
//  Famo
//
//  Created by 엔나루 on 2022/10/08.
//

import Foundation
import FirebaseAuth

class LoginManager {
    
    func processLogin(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void ) {
        print("LoginManager: trying firebase Login")
        print("id: \(email)")
        //print("pw: \(password)")
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            
            completion(authResult, error)
        }
    }
    
    func processSignUp(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        print("LoginManager: trying firebase Signup")
        print("id: \(email)")
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(authResult, error)
        }
    }
    
    func handleLoginError(_ error: Error, completion: @escaping (String, String) -> Void ) {
        
        guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else { return }
        var alertTitle: String = ""
        var alertMessage: String = ""
        
        switch errorCode {
        case AuthErrorCode.networkError:
            alertTitle = "오류"
            alertMessage = "네트워크 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
        case AuthErrorCode.userNotFound:
            alertTitle = "로그인 실패"
            alertMessage = "등록되지 않은 아이디 입니다. 회원가입을 진행해 주세요."
        case AuthErrorCode.userTokenExpired:
            alertTitle = "로그인 실패"
            alertMessage = "사용자 정보가 변경되었습니다. 다시 로그인해 주세요."
        case AuthErrorCode.invalidEmail:
            alertTitle = "이메일 확인"
            alertMessage = "잘못된 이메일 입니다."
        case AuthErrorCode.wrongPassword:
            alertTitle = "비밀번호 확인"
            alertMessage = "잘못된 비밀번호 입니다."
        case AuthErrorCode.tooManyRequests:
            alertTitle = "오류"
            alertMessage = "네트워크 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
        default:
            ()
        }
        
        completion(alertTitle, alertMessage)
    }
    
    func handleSigUpError(_ error: Error, completion: @escaping (String, String) -> Void ) {
        guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else { return }
        var alertTitle: String = ""
        var alertMessage: String = ""
        
        switch errorCode {
        case AuthErrorCode.networkError:
            alertTitle = "오류"
            alertMessage = "네트워크 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
        case AuthErrorCode.invalidEmail:
            alertTitle = "이메일 확인"
            alertMessage = "입력하신 이메일이 형식에 맞지 않습니다."
        case AuthErrorCode.emailAlreadyInUse:
            alertTitle = "오류"
            alertMessage = "이미 회원가입된 이메일 입니다."
        case AuthErrorCode.weakPassword:
            alertTitle = "비밀번호 확인"
            alertMessage = "비밀번호가 너무 취약합니다."
        case AuthErrorCode.tooManyRequests:
            alertTitle = "오류"
            alertMessage = "네트워크 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
        default:
            ()
        }
        
        completion(alertTitle, alertMessage)
    }
}
