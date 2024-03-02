//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by GiyaDev on 02.03.2024.
//

import Foundation
import UIKit

final class AuthViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        //IMAGE
        
        let logo = UIImage(named: "auth_screen_logo")
        let imageView = UIImageView(image: logo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
        imageView.heightAnchor.constraint(equalToConstant: 60),
        imageView.widthAnchor.constraint(equalToConstant: 60),
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        //BUTTON
        
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.layer.cornerRadius = 16
        loginButton.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
        loginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 640)
        ])
        
    }
}
