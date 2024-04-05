//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by GiyaDev on 04.02.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    var photoId: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    } ()
    
    var likeButtonTapped: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
    }
    
    func configure(with photo: Photo) {
        self.photoId = photo.id
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: URL(string: photo.thumbImageURL),
            placeholder: UIImage(named: "Stub"),
            options: [
                .transition(.fade(0.2)),
                .processor(DownsamplingImageProcessor(size: cellImage.bounds.size))
            ]
        )
        
        if let createdAt = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            dateLabel.text = "Date not available"
        }
        
        
        let likeImage = photo.isLiked ? UIImage(named: "like_on"): UIImage(named: "like_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let currentImage = likeButton.image(for: .normal), let photoId = self.photoId else {
            print("Error: photoId is nil")
            return
        }
        
        let isLiked = currentImage == UIImage(named: "like_on")
        let newImage = isLiked ? UIImage(named: "like_off") : UIImage(named: "like_on")
        likeButton.setImage(newImage, for: .normal)
        
        ImagesListService.shared.changeLike(photoId: photoId, isLiked: isLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Like status changed successfully")
                    self?.likeButtonTapped?(isLiked)
                case .failure(let error):
                    print("Failed to change like status: \(error.localizedDescription)")
                }
            }
        }
    }
}
