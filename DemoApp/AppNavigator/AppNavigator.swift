//
//  AppNavigator.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import Foundation
import UIKit

@objc class AppNavigator: NSObject {

    static let shared = AppNavigator()
    
    private override init() {
        super.init()
    }
    
    func pushLogInVC(InNavigationController navVC: UINavigationController) {
        DispatchQueue.main.async {
            let vc = LogInVC.init(nibName: "LogInVC", bundle: .main)
            vc.hidesBottomBarWhenPushed = true
            navVC.pushViewController(vc, animated: true)
        }
    }
    
    func showLogInVC(InWindow window: UIWindow) {
        DispatchQueue.main.async {
            let vc = LogInVC.init(nibName: "LogInVC", bundle: .main)
            let navVC = UINavigationController(rootViewController: vc)
            window.rootViewController = navVC
            window.makeKeyAndVisible()
        }
    }
    
    func showTabBar(InWindow window: UIWindow) {
        DispatchQueue.main.async {
            let tabbarVC = UIStoryboard(name: "TabBarVC", bundle: .main).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let navVC = UINavigationController(rootViewController: tabbarVC)
            window.rootViewController = navVC
            window.makeKeyAndVisible()
        }
    }
    
    
    func pushSignInVC(WithUserInfo userInfo: UserInfo, navVC: UINavigationController) {
        DispatchQueue.main.async {
            let vc = SignInVC(userInfo: userInfo)
            navVC.pushViewController(vc, animated: true)
        }
    }
    
    func getProfileVC(WithUserInfo userInfo: UserInfo) -> UserProfileVC {
        return UserProfileVC(userInfo: userInfo)
    }
    
    func getAccountSwitchVC(WithUserInfo currentUser: UserInfo, loggedInUsers: [UserInfo]) -> AccountSwitchVC {
        return AccountSwitchVC(currentUserInfo: currentUser, loggedInUserInfo: loggedInUsers)
    }
    
}
