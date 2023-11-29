//
//  ApiUtility.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import Foundation

struct ApiUtility {
    
    static let DOMAIN = "https://staging.shipday.com/"
    static let SIGN_IN_END_POINT = "\(ApiUtility.DOMAIN)mobile/carrier/signIn"
    internal init() {
        
    }
    
}

extension ApiUtility {
    static func makeApiCall(WithRequest request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    //MARK: - JSON String <-> NSDIctionary
    
    
    /// Dictionary -> JSON String
    static func getJsonString(fromDictionary dictionary : [AnyHashable : Any]?) -> String? {
        
        guard let tempDict = dictionary else { return nil }
        
        do {
            let messageJSONObject = try JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
            
            return String(data: messageJSONObject, encoding: .utf8)
        } catch _ {
            
        }
        return nil
    }
    
    /// JSON String -> Dictionary
    static func getJsonDictionary(fromServerResponse message : Any?) -> [AnyHashable : Any]? {
        
        guard let messageString = message as? String else { return nil }
            
        guard let messageData = messageString.data(using: .utf8) else { return nil }
        
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: messageData, options: .fragmentsAllowed) as? [AnyHashable : Any] else { return nil }
            
            return jsonObject
        } catch _ {
            
        }
        return nil
    }
}
