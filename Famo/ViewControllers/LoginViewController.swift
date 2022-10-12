//
//  LoginViewController.swift
//  Famo
//
//  Created by 엔나루 on 2022/10/08.
//

//이메일/비밀번호 로그인, 구글로그인, 애플로그인 제공
//회원가입창 이메일/비밀번호 입력창: 모달

import UIKit
import RxCocoa
import RxSwift
import FirebaseAnalytics
import FirebaseAuth
import SnapKit

class LoginViewController: UIViewController {
    
    private var logoImage = UIImageView()
    private var loginButton = UIButton(type: .roundedRect)
    
    private var emailField = UITextField()
    private var passwordField = UITextField()
    private var signUpButton = UIButton(type: .roundedRect)
    
    let disposeBag = DisposeBag()
    
    let loginManager = LoginManager()
    
//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImage.backgroundColor = .systemGray
        logoImage.layer.borderColor = UIColor.systemBrown.cgColor
        logoImage.layer.borderWidth = CGFloat(1)
        
        self.view.addSubview(logoImage)
        
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(100)
        }
        
        emailField.textAlignment = .left
        emailField.textContentType = .emailAddress
        emailField.placeholder = "이메일"
        emailField.textColor = .label
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.layer.borderColor = UIColor.systemGray.cgColor
        emailField.layer.borderWidth = CGFloat(1)
        emailField.layer.cornerRadius = 10
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        emailField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        emailField.leftViewMode = .always
        emailField.rightViewMode = .always
        
        configureEmailField()
        
        self.view.addSubview(emailField)
        
        emailField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(30)
            $0.top.equalTo(logoImage.snp.bottom).offset(30)
            $0.height.equalTo(50)
        }
        
        passwordField.textAlignment = .left
        passwordField.textContentType = .password
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "비밀번호"
        passwordField.textColor = .label
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.layer.borderColor = UIColor.systemGray.cgColor
        passwordField.layer.borderWidth = CGFloat(1)
        passwordField.layer.cornerRadius = 10
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        passwordField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        passwordField.leftViewMode = .always
        passwordField.rightViewMode = .always
        
        configurePasswordField()
        
        self.view.addSubview(passwordField)
        
        passwordField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(50)
            $0.top.equalTo(emailField.snp.bottom).offset(15)
        }
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.label, for: .normal)
        signUpButton.backgroundColor = .systemYellow
        signUpButton.layer.cornerRadius = 10
        
        configureSingUpButton()
        
        self.view.addSubview(signUpButton)
        
        signUpButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(30)
            $0.height.equalTo(50)
            $0.top.equalTo(passwordField.snp.bottom).offset(15)
        }
        
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(.systemBackground, for: .normal)
        loginButton.backgroundColor = .systemTeal
        loginButton.layer.cornerRadius = 10
        
        rxConfigureLogin()
        
        self.view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30)
            $0.height.equalTo(50)
            $0.top.equalTo(passwordField.snp.bottom).offset(15)
            $0.left.equalTo(signUpButton.snp.right).offset(15)
            $0.width.equalTo(signUpButton.snp.width)
        }
    }
    
    //바깥 터치 시 키보드 내려가도록 설정
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.emailField.layer.borderColor = UIColor.systemGray.cgColor
        self.passwordField.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //자동로그인
        if UserDefaults.standard.value(forKey: "UID") != nil {
            LogManager.shared.loginSuccess()
            self.navigateToNewMemo()
        }
    }
}

//MARK: rxMethods
extension LoginViewController {
    func rxConfigureLogin() {
        loginButton.rx.tap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.performLogin()
                
            })
            .disposed(by: disposeBag)
    }
    
    func configureEmailField() {
        //return 등 입력 시 비밀번호 창으로 가도록 설정
        self.emailField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe( { [weak self] _ in
                guard let self = self else { return }
                self.emailField.resignFirstResponder()
                self.emailField.layer.borderColor = UIColor.systemGray.cgColor
                self.passwordField.becomeFirstResponder()
                self.passwordField.layer.borderColor = UIColor.systemTeal.cgColor
            })
            .disposed(by: disposeBag)
        
        self.emailField.rx.controlEvent(.editingDidBegin)
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.emailField.layer.borderColor = UIColor.systemTeal.cgColor
                self.passwordField.layer.borderColor = UIColor.systemGray.cgColor
            })
            .disposed(by: disposeBag)
    }
    
    func configurePasswordField() {
        self.passwordField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe( { [weak self] _ in
                guard let self = self else { return }
                self.passwordField.resignFirstResponder()
                self.passwordField.layer.borderColor = UIColor.systemGray.cgColor
                
            })
            .disposed(by: disposeBag)

        self.passwordField.rx.controlEvent(.editingDidBegin)
            .subscribe( { [weak self] _ in
                guard let self = self else { return }
                self.emailField.resignFirstResponder()
                self.emailField.layer.borderColor = UIColor.systemGray.cgColor
                self.passwordField.layer.borderColor = UIColor.systemTeal.cgColor
            })
            .disposed(by: disposeBag)
    }
    
    func configureSingUpButton() {
        self.signUpButton.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.performSignUp()
        })
        .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    func performLogin() {
        guard let email = self.emailField.text,
              !email.isEmpty else {
            //alert
            return
        }
        guard let password = self.passwordField.text,
              !password.isEmpty else {
            //alert
            return
        }
        
        self.loginManager.processLogin(email: email, password: password) { result, error in
            if let result = result {
                let uid = result.user.uid
                UserDefaults.standard.set(uid, forKey: "UID")
                LogManager.shared.loginSuccess()
                self.navigateToNewMemo()
            } else if let error = error {
                
                LogManager.shared.loginFailure(emailInput: email, passwordInput: password)
                
                self.loginManager.handleLoginError(error) { alertTitle, alertMessage in
                    AppDelegate.openAlert(
                        vc: self,
                        title: alertTitle,
                        message: alertMessage,
                        alertStyle: .alert,
                        actionTitles: ["확인"],
                        actionStyles: [.default],
                        actions: [
                            { _ in
                                ()
                            }
                        ]
                    )
                }
            }
        }
    }
    
    func performSignUp() {
        guard let email = self.emailField.text,
              !email.isEmpty else {
            //alert
            AppDelegate.openAlert(
                vc: self,
                title: "이메일 확인",
                message: "이메일이 없습니다.",
                alertStyle: .alert,
                actionTitles: ["확인"],
                actionStyles: [.default],
                actions: [{_ in
                    ()
                }])
            
            return
        }
        guard let password = self.passwordField.text,
              !password.isEmpty else {
            //alert
            AppDelegate.openAlert(
                vc: self,
                title: "비밀번호 확인",
                message: "비밀번호가 없습니다.",
                alertStyle: .alert,
                actionTitles: ["확인"],
                actionStyles: [.default],
                actions: [{_ in
                    ()
                }])
            return
        }
        
        self.loginManager.processSignUp(email: email, password: password) { result, error in
            if let result = result {
                let uid = result.user.uid
                
                UserDefaults.standard.set(uid, forKey: "UID")
                LogManager.shared.signUpSuccess()
                
                self.navigateToNewMemo()
            } else if let error = error {
                
                LogManager.shared.signUpFailure()
                
                self.loginManager.handleSigUpError(error) { alertTitle, alertMessage in
                    AppDelegate.openAlert(
                        vc: self,
                        title: alertTitle,
                        message: alertMessage,
                        alertStyle: .alert,
                        actionTitles: ["확인"],
                        actionStyles: [.default],
                        actions: [
                            { _ in
                                ()
                            }
                        ]
                    )
                }
            }
        }
    }
    
    func navigateToNewMemo() {
        self.navigationController?.pushViewController(NewMemoViewController(), animated: true)
    }
}
