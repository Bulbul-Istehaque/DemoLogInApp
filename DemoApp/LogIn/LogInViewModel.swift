//
//  LogInViewModel.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import Foundation

protocol LogInViewModelDelegateProtocol: NSObject {
    
}

struct LogInViewModel {
    
    unowned let delegate: LogInViewModelDelegateProtocol
    
    let logInService: LogInNetworkProtocol
    
    init(delegate: LogInViewModelDelegateProtocol, signInService: LogInNetworkProtocol) {
        self.delegate = delegate
        self.logInService = signInService
    }
    
    internal func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func logIn(WithEmail email: String, password: String, _ completion:@escaping(_ success: Bool, _ errorReason: String?) -> Void) {
        
        if email.count == 0 {
            completion(false, "Email is empty")
            return
        }
        
        if password.count == 0 {
            completion(false, "Password is empty")
            return
        }
        
        let isValidEmailFormat = isValidEmailFormat(email)
        
        if isValidEmailFormat == false {
            completion(false, "Invalid email format")
            return
        }
        
        self.logInService.requestSignIn(WithEmail: email, password: password) { userInfo, error in
            
            if let err = error {
                completion(false, err.reason)
                return
            }
            
            guard let tempUserInfo = userInfo else {
                completion(false, "Something went wrong")
                return
            }
            
            var success = UserAccountService.saveUserInfo(tempUserInfo)
            
            if success == false {
                completion(false, "Could not load User")
                return
            }
            
            success = UserAccountService.saveUserPass(password, forUser: tempUserInfo.userID)
            
            UserAccountService.saveUserIDAtLoggedInUserIDs(tempUserInfo.userID)
            
            UserAccountService.setSignInUser(tempUserInfo.userID)
            
            completion(true, nil)
            
            AppManager.shared.appState = .LOGGED_IN
        }
        
    }
}




