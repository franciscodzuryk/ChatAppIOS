//
//  StayledButton.swift
//  ChatApp
//
//  Created by Fernando garay on 22/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setStayledButton(){
        layer.borderWidth = 1
        backgroundColor = #colorLiteral(red: 0, green: 0.5948191285, blue: 0, alpha: 1)
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 8
    }
}
