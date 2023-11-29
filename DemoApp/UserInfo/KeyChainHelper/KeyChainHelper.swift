//
//  KeyChainHelper.swift
//  DemoApp
//
//  Created by Bul on 27/11/23.
//

import Foundation

struct KeyChainHelper {
    
    /// Singleton Obj
    static let shared = KeyChainHelper()
    
    private init() {
        
    }
    
    /// Save Data for service and account
    func save(_ data: Data, service: String, account: String) -> Bool {
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // Add data in query to keychain
        var status = SecItemAdd(query, nil)
        
        if status == errSecSuccess {
            return true
        }
        
        debugPrint("KeyChainHelper save Error: \(status)")
        
        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            status = SecItemUpdate(query, attributesToUpdate)
            
            if status == errSecSuccess {
                return true
            }
            
            debugPrint("KeyChainHelper save Error: \(status)")
        }
        
        return false
    }
    
    /// Read Data for service and account
    func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query, &result)
        if status != errSecSuccess {
            debugPrint("KeyChainHelper read Error: \(status)")
        }
        return (result as? Data)
    }
    
    /// Delete Data for service and account
    func delete(service: String, account: String) -> Bool {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        let status = SecItemDelete(query)
        
        if status != errSecSuccess {
            debugPrint("KeyChainHelper delete Error: \(status)")
            return false
        }
        
        return true
    }


    
}
