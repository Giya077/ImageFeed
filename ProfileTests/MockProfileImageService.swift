//
//  MockProfileImageService.swift
//  ProfilePresenterTests
//
//  Created by GiyaDev on 28.04.2024.
//

import Foundation
@testable import ImageFeed

class MockProfileImageService: ProfileImageServiceProtocol {
    var avatarURL: String? = "https://example.com/avatar.jpg"
}
