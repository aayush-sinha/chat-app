//
//  SettingsViewController.swift
//  AppTest
//
//  Created by SR/DEV/L/295 on 27/11/24.
//

import UIKit

class SettingsViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = ChatManager.shared.currentUser
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        addConstraints()
    }

    @objc private func didTapSignOut() {
        ChatManager.shared.signOut()
        let vc = UINavigationController(rootViewController: LoginViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    

}
