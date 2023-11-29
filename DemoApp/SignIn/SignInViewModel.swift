//
//  SignInViewModel.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import Foundation

protocol SignInViewModelDelegateProtocol: NSObject {
    
    
    
}

struct SignInViewModel {
    
    unowned var delegate: SignInViewModelDelegateProtocol
    
    let signInService: SignInServiceProtocol
    
    init(delegate: SignInViewModelDelegateProtocol, signInService: SignInServiceProtocol) {
        self.delegate = delegate
        self.signInService = signInService
    }
    
    func singIn(WithUserID userID: String, password: String) -> Bool {
        let success = signInService.signIn(WithUserID: userID, password: password)
        
        UserAccountService.setSignInUser(userID)
        
        return success
    }
}
