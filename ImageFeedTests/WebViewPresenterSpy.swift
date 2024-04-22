//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by GiyaDev on 19.04.2024.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: (any ImageFeed.WebViewViewControllerProtocol)?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
