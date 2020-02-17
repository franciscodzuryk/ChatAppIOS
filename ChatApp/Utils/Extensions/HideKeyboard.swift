//
//  HideKeyboard.swift
//  ChatApp
//
//  Created by Fernando garay on 22/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboardWhenTappedAroundTriggered))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboardWhenTappedAroundTriggered() {
        view.endEditing(true)
    }
}
