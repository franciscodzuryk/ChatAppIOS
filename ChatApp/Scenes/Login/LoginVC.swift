//
//  Login.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 14/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import UIKit

protocol LoginViewInterface: class {
    func networkError(error:Error)
    func login(user: User)
    func login(company: Company)
    func selectLoginMode(loginAsCompany: Bool)
}

class LoginVC: UIViewController {
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var demoModeSwitch: UISwitch!
    @IBOutlet private weak var loginAsCompany: UISwitch!
    
    private var ctrler: LoginCtrler!
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setStayledButton()
        hideKeyboardWhenTappedAround()
        if LocalStorage.isDemoMode() {
            ctrler = LoginCtrler(self, apiUserClient: APIUserDemo(), apiCompanyClient: APICompanyDemo())
        } else {
            ctrler = LoginCtrler(self, apiUserClient: APIUserClient(), apiCompanyClient: APICompanyClient())
        }
        demoModeSwitch.isOn = LocalStorage.isDemoMode()
        userNameTextField.text = LocalStorage.getLoginName()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            userNameTextField.setAlertStyle(text: "Please enter a user Name")
            userNameTextField.setNeedsLayout()
            userNameTextField.layoutIfNeeded()
            userNameTextField.becomeFirstResponder()
            return
        }
        ctrler.login(name: userName)
    }

    @IBAction func enableDemoModeAction(_ sender: Any) {
        LocalStorage.setDemoMode(demoModeSwitch.isOn)
        if LocalStorage.isDemoMode() {
            ctrler = LoginCtrler(self, apiUserClient: APIUserDemo(), apiCompanyClient: APICompanyDemo())
        } else {
            ctrler = LoginCtrler(self, apiUserClient: APIUserClient(), apiCompanyClient: APICompanyClient())
        }
    }
    
    @IBAction func loginAsCompanyAction(_ sender: Any) {
        ctrler.loginAsCompany = loginAsCompany.isOn
    }
}

extension LoginVC: LoginViewInterface {
    func networkError(error: Error) {
        let dialog = DialogViewController.dialogWithTitle(title: "Network Error", message: error.localizedDescription, cancelTitle: "Ok")
        dialog.show(inViewController: self)
    }
    
    func login(user: User) {
        LocalStorage.setUser(user)
        guard let rootVC = UIStoryboard(name: "ChatVC", bundle: nil).instantiateViewController(withIdentifier: "ChatNC") as? UINavigationController else {
//            Show Error
            return
        }
        showRootViewController(navigationController: rootVC)
    }
    
    func login(company: Company) {
        guard let rootVC = UIStoryboard(name: "ContactsVC", bundle: nil).instantiateViewController(withIdentifier: "ContactsVC") as? UINavigationController else {
//            Show Error
            return
        }
        showRootViewController(navigationController: rootVC)
    }
    
    private func showRootViewController(navigationController: UINavigationController) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.rootViewController = navigationController
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.5
        UIView.transition(with: window, duration: duration, options: options, animations: {})
    }
    
    func selectLoginMode(loginAsCompany: Bool) {
        self.loginAsCompany.isOn = loginAsCompany
        loginButton.setTitle(loginAsCompany ? "Login as Company" : "Login as User", for: .normal)
    }
}
