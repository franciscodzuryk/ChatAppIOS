//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Fernando garay on 22/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageRightConstraint: NSLayoutConstraint!
    private var messageType = MessageType.sentMessage
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureCell(type: MessageType, text: String){
        messageLabel.text = text
        messageType = type
    }
    
    override func layoutSubviews() {
        switch messageType {
        case .recivedMessage:
            backView.backgroundColor = .gray
            backView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 8)
            messageLeftConstraint.constant = 10
            messageRightConstraint.constant = 30
        case .sentMessage:
            backView.backgroundColor = .lightGray
            backView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius:8)
            messageLeftConstraint.constant = 30
            messageRightConstraint.constant = 10
        default:
            return
        }
        super.layoutSubviews()
    }
}
