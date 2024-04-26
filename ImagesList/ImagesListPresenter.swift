//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by GiyaDev on 24.04.2024.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    func setView(_ view: ImagesListViewProtocol)
    func viewDidLoad()
    func didSelectPhoto(at indexPath: IndexPath)
    func toggleLike(for indexPath: IndexPath)
}

class ImagesListPresenter: ImagesListPresenterProtocol {
    private weak var view: ImagesListViewProtocol?
    private var imagesListService = ImagesListService.shared
    
    init(imagesListService: ImagesListService) {
        self.imagesListService = imagesListService
    }
    
    func setView(_ view: ImagesListViewProtocol) {  // Новый метод для установки view
        self.view = view
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func didSelectPhoto(at indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        print("Did select photo at indexPath: \(indexPath)")
        view?.performSegueToSingleImage(with: photo)
    }
    
    func toggleLike(for indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        let isLiked = !photo.isLiked
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLiked: isLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success:
                    self?.view?.updateCellLikeStatus(at: indexPath, isLiked: isLiked)
                    UIBlockingProgressHUD.dismiss()
                case.failure(let error):
                    print("Failed to toggle like: \(error.localizedDescription)")
                }
            }
        }
    }
}
