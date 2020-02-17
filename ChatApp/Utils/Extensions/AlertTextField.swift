//
//  AlertTextField.swift
//  ChatApp
//
//  Created by Fernando garay on 22/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setAlertStyle(text: String){
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.red.cgColor
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: text,
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
}
