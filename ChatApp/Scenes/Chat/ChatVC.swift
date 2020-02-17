//
//  ChatVC.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 14/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import UIKit

protocol ChatViewInterface: class {
    func networkError(error:Error)
    func showStatus(company: Company)
    func showMessages(messages: [Message])
    func askPlayVideo()
}

protocol ChatCtrler {
    func startPolling()
    func stopPolling()
    func sendMessage(message: Message)
    var user: User { get set }
}

class ChatVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageTextView: UITextView! {
        didSet {
            messageTextView.layer.cornerRadius = 5;
            messageTextView.layer.masksToBounds = true;
            messageTextView.becomeFirstResponder()
        }
    }
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet private weak var textFiedViewButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageContainerHeightConstraint: NSLayoutConstraint!
    
    private var ctrler: ChatCtrler!
    var user = LocalStorage.getUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        tableView.separatorStyle = .none
        sendButton.setStayledButton()
        messageTextView.delegate = self
        
        guard let user = user else {
            return
        }
        self.title = user.name
        
        if LocalStorage.isLoggedAsCompany() {
            ctrler = ChatCompanyCtrler(self, apiClient: LocalStorage.isDemoMode() ? APICompanyDemo() : APICompanyClient() , user: user)
        } else {
            ctrler = ChatUserCtrler(self, apiClient: LocalStorage.isDemoMode() ? APIUserDemo() : APIUserClient(), user: user)
        }
        
        if LocalStorage.isLoggedAsCompany() {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Bill", style: .done, target: self, action: #selector(billTapped))
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ctrler.startPolling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        ctrler.stopPolling()
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        guard let messageText = messageTextView.text else {
            return
        }
        let message = Message(userId: ctrler.user.id ?? 0, message: messageText, type: .sentMessage, bill: nil)
        sendMessage(message: message)
    }
    
    @objc func billTapped(sender: UIBarButtonItem) {
        let billVC = BillVC.create()
        billVC.action = { [weak self] (message) in
            guard let self = self else {
                return
            }
            self.sendMessage(message: message)
        }
        billVC.show(inViewController: self)
    }
    
    private func sendMessage(message: Message) {
        let indexPath = IndexPath(row: ctrler.user.msgs.count, section:0)
        ctrler.user.msgs.append(message)
        messageTextView.text = ""
        messageContainerHeightConstraint.constant = 90
        tableView.insertRows(at: [indexPath], with: .right)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        ctrler.sendMessage(message: message)
    }
    
    private func showPlayVideo() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PlayVideoVC", bundle: nil)
        guard let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlayVideoVC") as? PlayVideoVC else {
//            Show Error
            return
        }
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if notification.name == UIResponder.keyboardWillHideNotification {
                textFiedViewButtonConstraint.constant = 0
            } else {
                textFiedViewButtonConstraint.constant = keyboardHeight
            }
        }
    }
}

extension ChatVC: ChatViewInterface {
    
    func networkError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            let dialog = DialogViewController.dialogWithTitle(title: "Network Error", message: error.localizedDescription, cancelTitle: "Ok")
            dialog.show(inViewController: self)
        }
    }
    
    func showStatus(company: Company) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.title = company.name
        }
    }
    
    func showMessages(messages: [Message]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            var indexPaths = [IndexPath]()
            let newCount = self.ctrler.user.msgs.count + messages.count
            for i in self.ctrler.user.msgs.count..<newCount {
                indexPaths.append(IndexPath(row: i, section:0))
            }
            self.ctrler.user.msgs.append(contentsOf: messages)
            self.tableView.insertRows(at: indexPaths, with: .left)
            if let lastIndex = indexPaths.last {
                self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
            }
        }
    }
    
    func askPlayVideo() {
        let dialog = DialogViewController.dialogWithTitle(title: "Wait listening music", message: "Listen to music while waiting for the Company connecting.", cancelTitle: "No")
        dialog.setActionTitle(title: "Yes please!") {
            self.showPlayVideo()
        }
        dialog.show(inViewController: self)
    }
}

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ctrler.user.msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = ctrler.user.msgs[indexPath.row]
        if message.type == .bill {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell") as! BillTableViewCell
            cell.configureCell(bill: message.bill)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageTableViewCell
            cell.configureCell(type: message.type, text: message.message)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutSubviews()
    }
    
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
    
        if newSize.height > 40 && newSize.height < 160 {
            messageContainerHeightConstraint.constant = 90 + newSize.height - 40
        }
    }
}
