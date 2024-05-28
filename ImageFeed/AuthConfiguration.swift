//
//  Constants.swift
//  ImageFeed
//
//  Created by GiyaDev on 01.03.2024.
//

import Foundation


enum Constants {
    static let accessKey = "wnmabgtUsRiGP9nzEKk9hHIBrRAznuL6o5HRKpPfw8k"
    static let secretKey = "Qe6Dy9MCXyUz27wuLdGKNFvyxy3Ppc7mmXcA3aGytaM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authURLString: Constants.unsplashAuthorizeURLString)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI : String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
