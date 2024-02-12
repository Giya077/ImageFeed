//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by GiyaDev on 04.02.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    private let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
            super.layoutSubviews()
            
            // Устанавливаем рамку градиентного слоя на рамку dateLabel
            gradientLayer.frame = dateLabel.bounds
            
            // Устанавливаем цвета для градиента
        gradientLayer.colors = [UIColor(red: 1, green: 2, blue: 3, alpha: 0.1).cgColor, UIColor.darkGray.cgColor]
            
            // Устанавливаем точки начала и конца градиента
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 3.0)
            
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 5    
     }
 }
