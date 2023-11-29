//
//  UserInfo.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import Foundation
import UIKit
import SDWebImage

@objc class UserAccountService: NSObject {
    
    // MARK: - UserDefault Keys Logged Users
    static internal let LOGGED_USER = "LOGGED_USER"
    static internal let LOGGED_USERS = "PREVIOUS_LOGGED_USER"
    
    // MARK: - UserAccountKeys
    struct UserAccountKeys {
        static internal let userType = "userType"
        static internal let userID = "userID"
        static internal let name = "name"
        static internal let email = "email"
        static internal let imagePath = "imagePath"
        static internal let thumbnailPath = "thumbnailPath"
        static internal let companyID = "companyID"
        static internal let companyName = "companyName"
        static internal let accessToken = "accessToken"
        static internal let refreshToken = "refreshToken"
        
        static internal let EMAIL_USERID = "EMAIL_USERID_"
    }
    
    /// Current Account User
    static var currentUser: UserInfo? {
        
        get {
            
            guard let userID = UserAccountService.getSignInUserID() else {
                return nil
            }
            /*
            guard let pass = UserInfo.getUserPass(forUser: userID)  else {
                return nil
            }
            */
            
            return UserAccountService.getUserInfo(ForUserID: userID)
        }
        
    }
    
    static func getSignInUserID() -> String? {
        
        guard let loggedUser = UserDefaults.standard.value(forKey: LOGGED_USER) as? String, loggedUser.count > 0 else {
            return nil
        }
        return loggedUser
    }
    
    static func setSignInUser(_ userID: String) {
        UserDefaults.standard.setValue(userID, forKey: LOGGED_USER)
    }
    
    static func removeSignInUser() {
        UserDefaults.standard.removeObject(forKey: LOGGED_USER)
    }
    
    static func removeLoggedUsers() -> Bool {
        let users = loggedInUsers()
        
        var success = false
        
        for user in users {
            success = removeLogged(User: user)
            if success == false {
                let saveSuccess = saveUserInfo(user) // Revert Back The User
                if let tempCurUser = currentUser {
                    
                } else {
                    setSignInUser(user.userID)
                    setAppStateForCurrentUser()
                }
                
                return false
            }
        }
        
        removeSignInUser()
        
        setAppStateForCurrentUser()
        
        return true
    }
    
    static func removeLogged(User user: UserInfo) -> Bool {
        return removeUserInfo(user)
    }
    
    
    //MARK: - User Pass
    /// Save User Pass In Key Chain
    static func saveUserPass(_ password: String, forUser userdID: String) -> Bool {
        return SecureDataSaveService.saveData(password, forUserID: userdID, type: .PASSWORD)
    }
    
    /// Get User Pass From Key Chain
    static func getUserPass(forUser userdID: String) -> String? {
        return SecureDataSaveService.retrieveData(ForUser: userdID, type: .PASSWORD)
    }
    
    /// Remove User Pass From Key Chain
    static func deleteUserPass(forUser userdID: String) -> Bool {
        return SecureDataSaveService.deleteData(ForUser: userdID, type: .PASSWORD)
    }
    
    
    //MARK: - All Logged In Users
    
    /// Users currently logged in
    static func loggedInUserIDs() -> [String] {
        
        guard let userIDArray = UserDefaults.standard.array(forKey: LOGGED_USERS) as? [String] else { return [] }
        
        return userIDArray
    }
    
    static func loggedInUsers() -> [UserInfo] {
        
        guard let userIDArray = UserDefaults.standard.array(forKey: LOGGED_USERS) as? [String] else { return [] }
        
        var users = [UserInfo]()
        
        for userID in userIDArray {
            if let user = UserAccountService.getUserInfo(ForUserID: userID) {
                users.append(user)
            }
        }
        
        return users
    }
    
    static func saveUserIDAtLoggedInUserIDs(_ userID: String) {
        
        if var userIDArray = UserDefaults.standard.array(forKey: LOGGED_USERS) as? [String] {
            if !userIDArray.contains(userID) {
                userIDArray.append(userID)
                UserDefaults.standard.setValue(userIDArray, forKey: LOGGED_USERS)
            }
        } else {
            UserDefaults.standard.setValue([userID], forKey: LOGGED_USERS)
        }
    }
    
    static func removeUserIDAtLoggedInUserIDs(_ userID: String) {
        
        guard var userIDArray = UserDefaults.standard.array(forKey: LOGGED_USERS) as? [String] else {
            return
        }
        
        userIDArray = userIDArray.filter {
            return $0 != userID
        }
        UserDefaults.standard.setValue(userIDArray, forKey: LOGGED_USERS)
    }
    
    /// Save Value: UserID Key: Email
    static func save(UserID userID: String, AgainstEmail email: String) {
        let key = "\(UserAccountKeys.EMAIL_USERID)\(email)"
        UserDefaults.standard.setValue(userID, forKey: key)
    }
    
    /// Remove Value: UserID Key: Email
    static func removeUserID(AgainstEmail email: String) {
        let key = "\(UserAccountKeys.EMAIL_USERID)\(email)"
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// Get Value: UserID Key: Email
    static func getUserID(FromEmail email: String) -> String? {
        let key = "\(UserAccountKeys.EMAIL_USERID)\(email)"
        guard let userID = UserDefaults.standard.value(forKey: key) as? String else { return nil }
        return userID
    }
    
    
    //MARK: - Store User Info
    
    /// Saving User Info
    static func saveUserInfo(_ userInfo: UserInfo) -> Bool {
        
        var userInfoDict = [
            UserAccountKeys.userID : userInfo.userID,
            UserAccountKeys.email : userInfo.email,
//            UserAccountKeys.accessToken : userInfo.accessToken,
//            UserAccountKeys.refreshToken : userInfo.refreshToken,
            
        ] as [String: Any]
        
        var success = SecureDataSaveService.saveData(userInfo.accessToken, forUserID: userInfo.userID, type: .ACCESS_TOKEN)
        
        if success == false {
            return false
        }
        
        success = SecureDataSaveService.saveData(userInfo.refreshToken, forUserID: userInfo.userID, type: .REFRESH_TOKEN)
        
        if success == false {
            return false
        }
        
        if let value = userInfo.name {
            userInfoDict[UserAccountKeys.name] = value
        }
        
        if let value = userInfo.name {
            userInfoDict[UserAccountKeys.name] = value
        }
        
        if let value = userInfo.userType {
            userInfoDict[UserAccountKeys.userType] = value
        }
        
        if let value = userInfo.imagePath {
            userInfoDict[UserAccountKeys.imagePath] = value
        }
        
        if let value = userInfo.thumbnailPath {
            userInfoDict[UserAccountKeys.thumbnailPath] = value
        }
        
        if let value = userInfo.companyID {
            userInfoDict[UserAccountKeys.companyID] = value
        }
        
        if let value = userInfo.companyName {
            userInfoDict[UserAccountKeys.companyName] = value
        }
        
        
        UserDefaults.standard.setValue(userInfoDict, forKey: userInfo.userID)
        
        UserAccountService.save(UserID: userInfo.userID, AgainstEmail: userInfo.email)
        
        return true
    }
    
    static func removeUserInfo(_ userInfo: UserInfo) -> Bool {
        
        var success = SecureDataSaveService.deleteData(ForUser: userInfo.userID, type: .ACCESS_TOKEN)
        if success == false {
            debugPrint("Removing access token from Key Chain failed")
            return false
        }
        success = SecureDataSaveService.deleteData(ForUser: userInfo.userID, type: .REFRESH_TOKEN)
        if success == false {
            debugPrint("Removing refresh token from Key Chain failed")
            return false
        }
        
        success = deleteUserPass(forUser: userInfo.userID)
        
        if success == false {
            debugPrint("Removing password from Key Chain failed")
        }
        
        UserDefaults.standard.removeObject(forKey: userInfo.userID)
        
        removeUserIDAtLoggedInUserIDs(userInfo.userID)
        UserAccountService.removeUserID(AgainstEmail: userInfo.email)
        clearProfilePicCacheForUser(userInfo)
        
        return success
    }
    
    /// Retrieving User Info
    static func getUserInfo(ForUserID userID: String) -> UserInfo? {
        
        guard userID.count > 0, let userInfoDict = UserDefaults.standard.value(forKey: userID) as? [String: Any] else {
            return nil
        }
        
        guard let email = userInfoDict[UserAccountKeys.email] as? String, email.count > 0 else {
            return nil
        }
        
        guard let accessToken = SecureDataSaveService.retrieveData(ForUser: userID, type: .ACCESS_TOKEN), accessToken.count > 0 else {
            return nil
        }
        
        guard let refreshToken = SecureDataSaveService.retrieveData(ForUser: userID, type: .REFRESH_TOKEN), refreshToken.count > 0 else {
            return nil
        }
        
       /*
        guard let accessToken = userInfoDict[UserAccountKeys.email] as? String, accessToken.count > 0 else {
            return nil
        }
        
        guard let refreshToken = userInfoDict[UserAccountKeys.refreshToken] as? String, refreshToken.count > 0 else {
            return nil
        }
        */
        
        var userType: String?
        var name: String?
        var imagePath: String?
        var thumbnailPath: String?
        var companyID: String?
        var companyName: String?
        
        if let tempVal = userInfoDict[UserAccountKeys.name] as? String {
            name = tempVal
        }
        
        if let tempVal = userInfoDict[UserAccountKeys.userType] as? String {
            userType = tempVal
        }
        
        if let tempVal = userInfoDict[UserAccountKeys.imagePath] as? String {
            imagePath = tempVal
        }
        
        if let tempVal = userInfoDict[UserAccountKeys.thumbnailPath] as? String {
            thumbnailPath = tempVal
        }
        
        if let tempVal = userInfoDict[UserAccountKeys.companyID] as? String {
            companyID = tempVal
        }
        
        if let tempVal = userInfoDict[UserAccountKeys.companyName] as? String {
            companyName = tempVal
        }
        
        return UserInfo(userType: userType, userID: userID, name: name, email: email, imagePath: imagePath, thumbnailPath: thumbnailPath, companyID: companyID, companyName: companyName, accessToken: accessToken, refreshToken: refreshToken)
    }
    
    /// Configures @b App State for Current User
    static func setAppStateForCurrentUser() {
        if let _ = UserAccountService.currentUser {
            AppManager.shared.appState = .LOGGED_IN
        } else {
            AppManager.shared.appState = .INITIAL
        }
    }
    
    /*
    /// Get User Profile Pic
    static func getProfilePic(ForUser userID: String) -> UIImage? {
        
        guard let directory = DirectoryManager.shared.getUserDirectory(ForUserID: userID) as? NSString else {
            return nil
        }
        
        guard let userInfo = UserAccountService.getUserInfo(ForUserID: userID) else {
            return nil
        }
        
        guard let imagePath = userInfo.imagePath as? NSString else {
            return nil
        }
        
        let fileName = imagePath.lastPathComponent
        if fileName.count == 0 {
            return nil
        }
        
        let filePath = directory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        
        return nil
    }
    */
    
    /// Clear Picture Cache For User
    static func clearProfilePicCacheForUser(_ userInfo: UserInfo) {
        guard let profileImgPath = userInfo.imagePath, let url = URL(string: profileImgPath) else { return }
                
        guard let cacheKey = SDWebImageManager.shared.cacheKey(for: url) else { return }
                
        SDImageCache.shared.removeImageFromDisk(forKey: cacheKey)
        SDImageCache.shared.removeImageFromMemory(forKey: cacheKey)
    }
    
}
