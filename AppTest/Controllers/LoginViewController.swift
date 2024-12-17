//
//  ViewController.swift
//  AppTest
//
//  Created by SR/DEV/L/295 on 26/11/24.
//

import UIKit

final class LoginViewController: UIViewController {

    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .secondarySystemBackground
        return field
    }()

    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Login"
        view.addSubview(usernameField)
        view.addSubview(signInButton)
        addConstraints()
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.becomeFirstResponder()
        if ChatManager.shared.isSignedIn {
            presentChatList(animated: false)
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            usernameField.widthAnchor.constraint(equalToConstant: 200),
            usernameField.heightAnchor.constraint(equalToConstant: 50),

            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            signInButton.widthAnchor.constraint(equalToConstant: 200),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func didTapSignIn() {
        usernameField.resignFirstResponder()
        guard let username = usernameField.text, !username.isEmpty else {
            return
        }
        ChatManager.shared.signIn(with: username) { [weak self] success in
            guard success else {
                return
            }
            print("logged in")
            DispatchQueue.main.async {
                self?.presentChatList()
                print("presenting chat list")
            }
        }
    }
    
    func presentChatList(animated: Bool = true) {
        print("presenting chat list")
        guard let vc = ChatManager.shared.createChannelList() else {
            return
        }
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapNewChannel))
        let tab = TabBarViewController(chatList: vc)
        tab.modalPresentationStyle = .fullScreen
        present(tab, animated: animated)
    }

    @objc private func didTapNewChannel() {
        let alert = UIAlertController(title: "Create Channel", message: "Enter a name for your channel", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            ChatManager.shared.createNewChannel(name: text)
        }))
        presentedViewController?.present(alert, animated: true)
    }

}

