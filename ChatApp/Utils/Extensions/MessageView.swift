//
//  MessageView.swift
//  ChatApp
//
//  Created by Fernando garay on 22/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import Foundation
import  UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
