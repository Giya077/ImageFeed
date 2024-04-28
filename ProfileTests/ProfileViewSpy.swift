//
//  ProfileViewSpy.swift
//  ProfilePresenterTests
//
//  Created by GiyaDev on 28.04.2024.
//

import XCTest
@testable import ImageFeed

class ProfileViewSpy: ProfileViewProtocol {
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var resetUICalled = false
    var updatedProfile: ProfileService.Profile?
    var presentedAlertController: UIViewController?

    func updateProfileDetails(_ profile: ProfileService.Profile) {
        updateProfileDetailsCalled = true
        updatedProfile = profile
    }

    func updateAvatar(with imageURL: String) {
        updateAvatarCalled = true
    }

    func resetUI() {
        resetUICalled = true
    }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentedAlertController = viewControllerToPresent as? UIAlertController
        // Do not call present here to avoid recursion
        // You can call completion block if needed
        completion?()
    }
}
