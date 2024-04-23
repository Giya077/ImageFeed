//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by GiyaDev on 16.02.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
    func updateProfileDetails(_ profile: ProfileService.Profile)
    func updateAvatar(with imageURL: String)
}

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    let profileService = ProfileService.shared
    
    var presenter: ProfilePresenterProtocol!
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        presenter = ProfilePresenter(view: self, profileService: profileService, profileImageService: ProfileImageService.shared, profileLogoutService: ProfileLogoutService.shared)
        
        view.backgroundColor = .ypBlack
        presenter.viewDidLoad()
        addLogoutButton()
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
    

    func updateProfileDetails(_ profile: ProfileService.Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio ?? ""
    }
    
    func updateAvatar(with imageURL: String) {
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
    
    @objc
    private func didTapButton() {
        
        let alertController = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Выход", style: .destructive) { [weak self] _ in
            ProfileLogoutService.shared.logout()
            self?.resetUI()
        }
        
        alertController.addAction(logoutAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func resetUI() {
        nameLabel.text = ""
        loginNameLabel.text = ""
        descriptionLabel.text = ""
        imageView.image = nil
    }
}
