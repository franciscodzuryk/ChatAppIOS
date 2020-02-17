//
//  ContactCell.swift
//  ChatAppSrv
//
//  Created by Luis Francisco Dzuryk on 23/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var msgCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.backView.layer.masksToBounds = true
        self.backView.layer.cornerRadius = 8.0
    }
    
    func setupCell(user: User) {
        nameLabel.text = user.name
        msgCountLabel.text = user.msgsCountStr
    }
}
