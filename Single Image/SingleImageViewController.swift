//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by GiyaDev on 18.02.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
