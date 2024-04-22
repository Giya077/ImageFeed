//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by GiyaDev on 19.04.2024.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: (any ImageFeed.WebViewPresenterProtocol)?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
}
