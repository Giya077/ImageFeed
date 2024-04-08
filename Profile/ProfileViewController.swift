//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by GiyaDev on 16.02.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        view.backgroundColor = .ypBlack
    
        setupUI()
        updateAvatar()
        addLogoutButton()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile)
        }
        
        observeProfileImageChanges()
    }
    
    private func setupUI() {
        
        //IMAGE
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        //NAME
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.numberOfLines = 0
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // LOGIN
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.numberOfLines = 0
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        loginNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //DESCRIPTION
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func addLogoutButton() {
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
    
    private func observeProfileImageChanges() {
           profileImageServiceObserver = NotificationCenter.default
            .addObserver(
               forName: ProfileImageService.didChangeNotification,
               object: nil,
               queue: .main
           ) { [weak self] _ in
               guard let self = self else { return }
               self.updateAvatar()
           }
//        updateAvatar()
       }
    
    private func updateProfileDetails(_ profile: ProfileService.Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio ?? ""
    }
    
    private func updateAvatar() {
           guard let profileImageURL = ProfileImageService.shared.avatarURL,
                 let url = URL(string: profileImageURL)
           else { return }
           
           let processor = RoundCornerImageProcessor(cornerRadius: 45)
           
           imageView.kf.indicatorType = .activity
           imageView.kf.setImage(
               with: url,
               placeholder: nil,
               options: [
                   .processor(processor),
                   .transition(.fade(0.5))
               ],
               completionHandler: { result in
                   switch result {
                   case .success(_):
                       break
                   case .failure(let error):
                       print("Failed to load Image: \(error)")
                   }
               }
           )
       }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @objc
    private func didTapButton() {
        ProfileLogoutService.shared.logout()
        resetUI()
    }
    
    private func resetUI() {
        nameLabel.text = ""
        loginNameLabel.text = ""
        descriptionLabel.text = ""
        imageView.image = nil
    }
}
