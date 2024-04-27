//
//  SpyImagesListPresenter.swift
//  ImagesListTests
//
//  Created by GiyaDev on 26.04.2024.
//
@testable import ImageFeed
import Foundation

class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var setViewCalled: Bool = false
    var performSegueCalled: Bool = false
    var updateCellLikeStatusCalled = false
    var didSelectPhotoCalled = false
    var view: ImagesListViewControllerProtocol?
    
    func updateTableViewAnimated() {}
    
    func updateCellLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
        updateCellLikeStatusCalled = true
        print("SpyImagesListView - updateCellLikeStatus called")
    }
    
    func performSegueToSingleImage(with photo: ImageFeed.Photo) {
        performSegueCalled = true
    }
    
    func didSelectPhoto(at indexPath: IndexPath) {
        didSelectPhotoCalled = true
    }
    
    func setView(_ view: ImagesListViewControllerProtocol) {
        setViewCalled = true
        self.view = view
        print("setViewCalled is set to true")
        print("Set view to: \(view)")
    }
}


