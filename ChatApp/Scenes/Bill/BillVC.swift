//
//  BillVC.swift
//  ChatAppSrv
//
//  Created by Luis Francisco Dzuryk on 25/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import UIKit

class BillVC: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var accontNumberTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var taxesTextField: UITextField!
    @IBOutlet private weak var totalTextField: UITextField!
    @IBOutlet private weak var dueDateTextField: UITextField!
    @IBOutlet private weak var cancelButtonCenterConstraint: NSLayoutConstraint!
    var action: ((_ message: Message) -> Void)?
    
    class func create() -> BillVC {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: className, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: className) as! BillVC
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setStayledButton()
        actionButton.setStayledButton()
    }
    
    func presentDialogViewController(_ baseViewController: UIViewController, viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        viewControllerToPresent.definesPresentationContext = true
        viewControllerToPresent.providesPresentationContextTransitionStyle = true
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        viewControllerToPresent.modalTransitionStyle = .crossDissolve
        
        baseViewController.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func show(inViewController: UIViewController) {
        presentDialogViewController(inViewController, viewControllerToPresent: self, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBillAction(_ sender: Any) {
        action?(Message(userId: 1, message: "", type: .bill, bill: Bill(userId: 1, accountNumber: accontNumberTextField.text ?? "",
                                                                        price: Double(priceTextField.text ?? "") ?? 0.0,
                                                                        taxes: Double(taxesTextField.text ?? "") ?? 0.0,
                                                                        dueDate: dueDateTextField.text ?? "",
                                                                        total: Double(totalTextField.text ?? "") ?? 0.0)))
        dismiss(animated: true, completion: nil)
    }
    
}
