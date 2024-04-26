

import UIKit
import Kingfisher
import ProgressHUD

protocol ImagesListViewProtocol: AnyObject {
    func updateTableViewAnimated()
    func updateCellLikeStatus(at indexPath: IndexPath, isLiked: Bool)
    func performSegueToSingleImage(with photo: Photo)
    func didSelectPhoto(at indexPath: IndexPath)
}


final class ImagesListViewController: UIViewController {
    private let showSingleImageSequeIdentifier = "ShowSingleImage"
    private var presenter: ImagesListPresenterProtocol!
    private var photos: [Photo] = []
    
    private let imagesListService = ImagesListService.shared
    private var imagesListControllerObserver: NSObjectProtocol?
    
    @IBOutlet
    private var tableView: UITableView!
    
    
    private lazy var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListPresenter(imagesListService: imagesListService)
        presenter.setView(self)
        setupTableView()
        observeImagesListControllerChanges()
        presenter.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func observeImagesListControllerChanges() {
        imagesListControllerObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
    }
    
    deinit {
        if let observer = imagesListControllerObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

extension ImagesListViewController: ImagesListViewProtocol {
    @objc func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates({
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }
    
    func updateCellLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
        DispatchQueue.main.async { [weak self] in
            if let cell = self?.tableView.cellForRow(at: indexPath) as? ImagesListCell {
                cell.updateLikeButton(isLiked: isLiked)
            }
        }
    }
    
    func performSegueToSingleImage(with photo: Photo) {
        print("Performing segue to SingleImageViewController with photo: \(photo)")
        if let indexPath = indexPath(for: photo) {
            performSegue(withIdentifier: showSingleImageSequeIdentifier, sender: indexPath)
        } else {
            print("Could not find indexPath for photo: \(photo)")
        }
    }
    
    private func indexPath(for photo: Photo) -> IndexPath? {
        guard let index = photos.firstIndex(where: { $0.id == photo.id }) else {
            return nil
        }
        return IndexPath(row: index, section: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSequeIdentifier,
           let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath {
            
            let photo = photos[indexPath.row]
            viewController.fullImageURL = photo.fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func didSelectPhoto(at indexPath: IndexPath) {
        presenter.didSelectPhoto(at: indexPath)
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select row at indexPath: \(indexPath)")
        didSelectPhoto(at: indexPath)
        //        performSegue(withIdentifier: showSingleImageSequeIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as! ImagesListCell
        let photo = photos[indexPath.row]
        cell.delegate = self
        cell.configure(with: photo)
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        return cell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        presenter.toggleLike(for: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showSingleImageSequeIdentifier,
//           let viewController = segue.destination as? SingleImageViewController,
//           let indexPath = sender as? IndexPath {
//
//            let photo = photos[indexPath.row]
//            viewController.fullImageURL = photo.fullImageURL
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }

//    @objc private func updateTableViewAnimated() {
//        let oldCount = photos.count
//        let newCount = imagesListService.photos.count
//        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
//
//        photos = imagesListService.photos
//
//        if oldCount != newCount {
//            tableView.performBatchUpdates({
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            }, completion: nil)
//        }
//    }

//extension ImagesListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return photos.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as! ImagesListCell
//
//        let photo = photos[indexPath.row]
//        cell.delegate = self // Устанавливаем контроллер в качестве делегата ячейки
//        cell.configure(with: photo)
//
//        return cell
//    }
//}
//
//extension ImagesListViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: showSingleImageSequeIdentifier, sender: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let photo = photos[indexPath.row]
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = photo.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
//        return cellHeight
//    }
//

//extension ImagesListViewController: ImagesListCellDelegate {
//    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        var photo = photos[indexPath.row]
//
//        let isLiked = !photo.isLiked // Инвертируем текущее состояние лайка
//
//        UIBlockingProgressHUD.show()
//        imagesListService.changeLike(photoId: photo.id, isLiked: isLiked) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    print("Like status changed successfully")
//                    photo.isLiked = isLiked
//                    cell.updateLikeButton(isLiked: isLiked) // Обновляем только кнопку лайка в ячейке
//                    UIBlockingProgressHUD.dismiss()
//                case .failure(let error):
//                    print("Failed to change like status: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
