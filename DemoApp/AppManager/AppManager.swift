//
//  AppManager.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import Foundation

@objc enum AppState: NSInteger {
    case INITIAL
    case LOGGED_IN
}


@objc class AppManager: NSObject {
    
    /// Singleton Object
    static let shared = AppManager()
    
    /// App State
    var appState: AppState = .INITIAL {
        didSet {
            
            switch appState {
            case .INITIAL:
                
                AppNavigator.shared.showLogInVC(InWindow: AppDelegate.getWindow())
                
                break
            case .LOGGED_IN:
                
                AppNavigator.shared.showTabBar(InWindow: AppDelegate.getWindow())
                
                break
            }
            
        }
    }
    
    private override init() {
        super.init()
        
        DirectoryManager.shared.dataSource = self
        
        NetworkRechability.shared.delegate = self
        
    }

    
}

//MARK: - DirectoryDataSourceProtocol
extension AppManager: DirectoryDataSourceProtocol {
    
    func getUserID() -> String? {
        
        guard let user = UserAccountService.currentUser else { return nil }
        
        return user.userID
    }
    
}

//MARK: - NetworkRechabilityDelegateProtocol
extension AppManager: NetworkRechabilityDelegateProtocol {
    
    func networkTypeChanged(_ networkType: NetworkType) {
        NotificationCenter.default.post(name: NSNotification.Name("NETWORK_INTERFACE_CHANGED"), object: nil)
    }
    
    func networkConnectionChanged(_ isConnected: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("NETWORK_CONNECTION_CHANGED"), object: nil)
    }
    
}


