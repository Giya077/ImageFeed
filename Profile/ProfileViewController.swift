//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by GiyaDev on 16.02.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        
        view.backgroundColor = .ypBlack
        
        // PROFILE IMAGE
        
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        //NAME
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.textColor = .white
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "YS Display Bold", size: 23)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.numberOfLines = 0
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // LOGIN
        
        let loginName = UILabel()
        loginName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginName)
        
        loginName.textColor = .ypGray
        loginName.text = "@ekaterina_nov"
        loginName.font = UIFont(name: "YS Display Regular", size: 13)
        loginName.numberOfLines = 0
        
        loginName.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        loginName.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //DESCRIPTION
        
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(description)
        
        description.textColor = .ypWhite
        description.text = "Hello, World!"
        description.font = UIFont(name: "YS Display Regular", size: 13)
        description.numberOfLines = 0
        
        description.topAnchor.constraint(equalTo: loginName.bottomAnchor, constant: 8   ).isActive = true
        description.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        description.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // LOGOUT BOTTON
        
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(self.didTapButton))
        
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
                
            }
        }
    }
}
