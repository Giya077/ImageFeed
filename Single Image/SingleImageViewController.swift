//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by GiyaDev on 18.02.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var fullImageURL: String?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SingleImageViewController loaded")
        backButton.accessibilityIdentifier = "nav back button white"
        imageView.accessibilityIdentifier = "zoomable image"
        print("ImageView accessibility identifier:", imageView.accessibilityIdentifier ?? "No identifier")
        setupScrollView()
        loadFullImage()
        imageView.contentMode = .scaleAspectFit
        scrollView.delegate = self
        
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: 51),
            shareButton.widthAnchor.constraint(equalToConstant: 51)
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    
    private func setupScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2.0

        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
              doubleTapGestureRecognizer.numberOfTapsRequired = 2
              scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
         let pointInView = recognizer.location(in: imageView)
         let zoomScaleFactor: CGFloat = min(scrollView.maximumZoomScale / 2, scrollView.zoomScale * 2)
         if scrollView.zoomScale != scrollView.minimumZoomScale {
             scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
         } else {
             let scrollViewSize = scrollView.bounds.size
             let w = scrollViewSize.width / zoomScaleFactor
             let h = scrollViewSize.height / zoomScaleFactor
             let x = pointInView.x - (w / 2.0)
             let y = pointInView.y - (h / 2.0)
             
             let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)
             scrollView.zoom(to: rectToZoomTo, animated: true)
         }
     }
    
    private func loadFullImage() {
        guard let fullImageURLString = fullImageURL, let fullImageURL = URL(string: fullImageURLString) else {
            print("Invalid full image URL")
            return
        }
        
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                // Установка изображения и масштабирование в scrollView
                self.imageView.image = imageResult.image
//                self.centerImageInScrollView()
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Занова", style: .default, handler: { [weak self] _ in
            self?.loadFullImage()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let horizontalPadding = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        let verticalPadding = max(0, (scrollViewSize.height - imageViewSize.height) / 2)

        // Установим масштабирование изображения
        let widthScale = scrollViewSize.width / image.size.width
        let heightScale = scrollViewSize.height / image.size.height
        let initialScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = initialScale
        scrollView.zoomScale = initialScale
        scrollView.maximumZoomScale = 2.0

//         Поднимаем изображение выше, устанавливая отрицательный отступ вниз
        let yOffset = max(0, (imageViewSize.height - scrollViewSize.height) / 2)
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding - yOffset, left: horizontalPadding, bottom: verticalPadding + yOffset, right: horizontalPadding)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImageInScrollView()
    }
    
    private func centerImageInScrollView() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        let horizontalPadding = max(0, (scrollViewSize.width - imageViewSize.width) / 2)

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}


