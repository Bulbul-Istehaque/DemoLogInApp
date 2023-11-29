//
//  UserInfo.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import Foundation

struct UserLogInRequest: Encodable {
    let email: String
    let password: String
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
    }
}

struct UserInfoResponse: Codable {
    
    let success: String
    let errorResponse: String?
    let userType: String?
    let userID: String?
    let name: String?
    let email: String?
    let imagePath: String?
    let thumbnailPath: String?
    let companyID: String?
    let companyName: String?
    var accessToken: String?
    var refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case errorResponse = "response"
        case userType = "user_type"
        case userID = "id"
        case name = "name"
        case email = "email_address"
        case imagePath = "image_path"
        case thumbnailPath = "thumbnail_image_path"
        case companyID = "company_id"
        case companyName = "company_name"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    static func getUserInfo(FromResponse response: UserInfoResponse) -> (UserInfo?, SignInError?)  {
        
        guard let userID = response.userID, userID.count > 0 else {
            return (nil, SignInError(reason: response.errorResponse ?? ""))
        }
        
        guard let email = response.email, email.count > 0 else {
            return (nil, SignInError(reason: response.errorResponse ?? ""))
        }
        
        guard let accessToken = response.accessToken, accessToken.count > 0 else {
            return (nil, SignInError(reason: response.errorResponse ?? ""))
        }
        
        guard let refreshToken = response.refreshToken, refreshToken.count > 0 else {
            return (nil, SignInError(reason: response.errorResponse ?? ""))
        }
        
        return (UserInfo(userType: response.userType, userID: userID, name: response.name, email: email, imagePath: response.imagePath, thumbnailPath: response.thumbnailPath, companyID: response.companyID, companyName: response.companyName, accessToken: accessToken, refreshToken: refreshToken), nil)
    }
}



struct SignInError {
    let reason: String
}



struct UserInfo {
    let userType: String?
    let userID: String
    let name: String?
    let email: String
    let imagePath: String?
    let thumbnailPath: String?
    let companyID: String?
    let companyName: String?
    var accessToken: String
    var refreshToken: String
}
