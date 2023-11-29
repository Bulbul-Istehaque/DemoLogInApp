//
//  UserDataSaveService.swift
//  DemoApp
//
//  Created by Bul on 27/11/23.
//

import Foundation

enum SecureDataType {
    case PASSWORD
    case ACCESS_TOKEN
    case REFRESH_TOKEN
}

struct SecureDataSaveService {
    
    static private let PASSWORD_SERVICE = "PASSWORD_SERVICE"
    static private let ACCESS_TOKEN_SERVICE = "ACCESS_TOKEN_SERVICE"
    static private let REFRESH_TOKEN_SERVICE = "REFRESH_TOKEN_SERVICE"
    
    private init() {
        
    }
    
    static func getService(FromType type: SecureDataType) -> String {
        switch type {
        case .PASSWORD:
            return SecureDataSaveService.PASSWORD_SERVICE
        case .ACCESS_TOKEN:
            return SecureDataSaveService.ACCESS_TOKEN_SERVICE
        case .REFRESH_TOKEN:
            return SecureDataSaveService.REFRESH_TOKEN_SERVICE
        }
    }
    
    static func saveData(_ data: String, forUserID userID: String, type: SecureDataType) -> Bool {
        
        guard data.count > 0, userID.count > 0 else {
            debugPrint("password or userID is empty")
            return false
        }
        
        guard let data = data.data(using: .utf8) else { return false }
        
        let service = SecureDataSaveService.getService(FromType: type)
        
        return KeyChainHelper.shared.save(data, service: service, account: userID)
    }
    
    static func retrieveData(ForUser userID: String, type: SecureDataType) -> String? {
        guard userID.count > 0 else {
            debugPrint("userID is empty")
            return nil
        }
        
        let service = SecureDataSaveService.getService(FromType: type)
        
        guard let passData = KeyChainHelper.shared.read(service: service, account: userID), let pass = String(data: passData, encoding: .utf8), pass.count > 0 else {
            return nil
        }
        
        return pass
    }
    
    static func deleteData(ForUser userID: String, type: SecureDataType) -> Bool {
        guard userID.count > 0 else {
            debugPrint("userID is empty")
            return false
        }
        
        let service = SecureDataSaveService.getService(FromType: type)
        
        return KeyChainHelper.shared.delete(service: service, account: userID)
    }
    
}
