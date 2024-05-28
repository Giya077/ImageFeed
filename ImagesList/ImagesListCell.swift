//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by GiyaDev on 04.02.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        likeButton.accessibilityIdentifier = "like button tapped"
    }
    
    func configure(with photo: Photo) {
        self.photoId = photo.id
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: URL(string: photo.regularImageURL),
            placeholder: UIImage(named: "Stub"),
            options: [
                .transition(.fade(0.9)),
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
    
    
    func updateLikeButton(isLiked: Bool) {
        DispatchQueue.main.async { [weak self] in
            let likeImage = isLiked ? UIImage(named: "like_on") : UIImage(named: "like_off")
            self?.likeButton.setImage(likeImage, for: .normal)
        }
    }
    
    
    @IBAction private func likeButtonPressed(_ sender: UIButton) {
        guard let currentImage = likeButton.image(for: .normal), let _ = self.photoId else {
            print("Error: photoId is nil")
            return
        }
        
        let isLiked = currentImage == UIImage(named: "like_on")
        let newImage = isLiked ? UIImage(named: "like_off") : UIImage(named: "like_on")
        likeButton.setImage(newImage, for: .normal)
        
        delegate?.imagesListCellDidTapLike(self)
    }
}
