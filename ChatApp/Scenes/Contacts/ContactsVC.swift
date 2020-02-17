//
//  ContactsVC.swift
//  ChatAppSrv
//
//  Created by Luis Francisco Dzuryk on 20/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import UIKit

protocol ContactsInterface: class {
    func networkError(error:Error)
    func showStatus(users: [User])
}

class ContactsVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private var ctrler: ContactsCtrler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ctrler = ContactsCtrler(self, apiClient: LocalStorage.isDemoMode() ? APICompanyDemo() : APICompanyClient())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ctrler.startPolling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ctrler.stopPolling()
    }
    
}

extension ContactsVC: ContactsInterface {
    
    func networkError(error: Error) {
        let dialog = DialogViewController.dialogWithTitle(title: "Network Error", message: error.localizedDescription, cancelTitle: "Ok")
        dialog.show(inViewController: self)
    }
    
    func showStatus(users: [User]) {
        self.ctrler.company.users = users
        tableView.reloadData()
    }
}

extension ContactsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ctrler.company.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        cell.setupCell(user: self.ctrler.company.users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChatVC", bundle: nil)
        guard let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else {
//            Show Error
            return
        }
        chatVC.user = self.ctrler.company.users[indexPath.row]
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class ContactsCtrler {
    private weak var view: ContactsInterface!
    private let apiClient: APICompanyClientInterface
    private var timer: DispatchSourceTimer?
    private var showNetworkError = true
    public var company = Company(name: "", status: .active)
    
    init(_ view: ContactsInterface, apiClient: APICompanyClientInterface) {
        self.view = view
        self.apiClient = apiClient
    }
    
    func startPolling() {
        let queue = DispatchQueue.global(qos: .background)
        timer = DispatchSource.makeTimerSource(queue: queue) as DispatchSourceTimer
        timer?.schedule(deadline: .now(), repeating: .seconds(8), leeway: .seconds(2))
        timer?.setEventHandler(handler: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.apiClient.getStatus(success: { (users) in
                self.showNetworkError = true
                if users.count > 0 && self.company.addUsers(users: users) {
                    DispatchQueue.main.async {
                        self.view.showStatus(users: self.company.users)
                    }
                }
            }, fail: { (error) in
                if self.showNetworkError {
                    DispatchQueue.main.async {
                        self.view.networkError(error: error)
                    }
                    self.showNetworkError = false
                }
            })
            
            self.apiClient.getAllMessages(success: { (msgsByUser) in
                self.showNetworkError = true
                if msgsByUser.count > 0 && self.company.addMessages(msgsByUser: msgsByUser) {
                    DispatchQueue.main.async {
                        self.view.showStatus(users: self.company.users)
                    }
                }
            }) { (error) in
                if self.showNetworkError {
                    DispatchQueue.main.async {
                        self.view.networkError(error: error)
                    }
                    self.showNetworkError = false
                }
            }
        })
        timer?.resume()
    }
    
    func stopPolling() {
        timer?.cancel()
        timer = nil
    }
}
