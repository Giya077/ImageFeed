//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by GiyaDev on 22.04.2024.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapLogout()
    func observeProfileImageChanges()
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let profileLogoutService: ProfileLogoutServiceProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewProtocol? = nil, profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol, profileLogoutService: ProfileLogoutServiceProtocol, profileImageServiceObserver: NSObjectProtocol? = nil) {
        self.view = view
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
        self.profileImageServiceObserver = profileImageServiceObserver
    }
    
    func viewDidLoad() {
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile)
        }
        observeProfileImageChanges()
        updateAvatar()
    }
    
    func didTapLogout() {
        profileLogoutService.logout() /// ????????/
    }
    
    func observeProfileImageChanges() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL else {
            return
        }
        // Update the avatar image in the view
        view?.updateAvatar(with: profileImageURL)
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
