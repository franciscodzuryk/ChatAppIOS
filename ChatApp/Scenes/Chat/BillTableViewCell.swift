//
//  BillTableViewCell.swift
//  ChatApp
//
//  Created by Fernando garay on 24/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    @IBOutlet private weak var accountNumber: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var taxes: UILabel!
    @IBOutlet private weak var dueDate: UILabel!
    @IBOutlet private weak var totalDue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configureCell(bill: Bill?) {
        guard let bill = bill else {
            return
        }
        accountNumber.text = bill.accountNumber
        productPrice.text = String(bill.price)
        taxes.text = String(bill.taxes)
        dueDate.text = bill.dueDate
        totalDue.text = String(bill.total)
    }
}
