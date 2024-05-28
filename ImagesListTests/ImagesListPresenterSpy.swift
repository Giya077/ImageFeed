//
//  1.swift
//  ImagesListTests
//
//  Created by GiyaDev on 27.04.2024.
//

import Foundation
@testable import ImageFeed

class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var didLoadCalled = false

    func setView(_ view: ImagesListViewControllerProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        didLoadCalled = true
    }

    func didSelectPhoto(at indexPath: IndexPath) {}

    func toggleLike(for indexPath: IndexPath) {}
}
