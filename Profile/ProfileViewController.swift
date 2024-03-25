//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by GiyaDev on 16.02.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    let profileService = ProfileService.shared
    
    let nameLabel = UILabel()
    let loginNameLabel = UILabel()
    let descriptionLabel = UILabel()
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        view.backgroundColor = .ypBlack
    
        updateAvatar()
        addLabels()
        addLogoutButton()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile)
        }
        
        observeProfileImageChanges()
    }
    
    private func addLabels() {
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
           profileImageServiceObserver = NotificationCenter.default.addObserver(
               forName: ProfileImageService.didChangeNotification,
               object: nil,
               queue: .main
           ) { [weak self] _ in
               guard let self = self else { return }
               self.updateAvatar()
           }
       }
    
    private func updateProfileDetails(_ profile: ProfileService.Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio ?? ""
    }
    
    private func updateAvatar() {
           // Remove previous image view if exists
//           imageView?.removeFromSuperview()
           
           guard let profileImageURL = ProfileImageService.shared.avatarURL,
                 let url = URL(string: profileImageURL)
           else {
               // Use placeholder image if profile image URL is nil
               let placeholderImage = UIImage(named: "tab_profile_active")
               let newImageView = UIImageView(image: placeholderImage)
               view.addSubview(newImageView)
               newImageView.translatesAutoresizingMaskIntoConstraints = false
               newImageView.contentMode = .scaleAspectFill
               newImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
               newImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
               newImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
               newImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
               
               imageView = newImageView
               return
           }
           
           let newImageView = UIImageView()
           view.addSubview(newImageView)
           newImageView.translatesAutoresizingMaskIntoConstraints = false
           newImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
           newImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
           newImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
           newImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
           
           imageView = newImageView
           
           imageView?.kf.setImage(with: url) { result in
               switch result {
               case .success(_):
                   // Do nothing
                   break
               case .failure(let error):
                   print("Failed to load image: \(error)")
               }
           }
       }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @objc
    private func didTapButton() {
        nameLabel.text = ""
        loginNameLabel.text = ""
        descriptionLabel.text = ""
    }
}
