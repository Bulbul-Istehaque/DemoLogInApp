//
//  SignInService.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import Foundation

protocol SignInServiceProtocol {
    func signIn(WithUserID userID: String, password: String) -> Bool
}

struct SignInService: SignInServiceProtocol {
    
    func signIn(WithUserID userID: String, password: String) -> Bool {
        
        return false
    }
    
}
