//
//  TabBarVC.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import Foundation
import UIKit

class TabBarVC: UITabBarController {
    
    var vcArray = [UIViewController]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpViews()
        
    }


    private func setUpViews() {
        self.navigationController?.navigationBar.isHidden = true
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        
        guard let user = UserAccountService.currentUser else {
            return
        }
        
        let userArray = UserAccountService.loggedInUsers()
        
        if userArray.count == 0 {
            return
        }
        
        let profileController = AppNavigator.shared.getProfileVC(WithUserInfo: user)
        let profileControllerItem = UITabBarItem(title: "Profile", image: UIImage(named: "account_normal"), selectedImage: UIImage(named: "account_pressed"))
        
        let profileNavVC = UINavigationController(rootViewController: profileController)
        
        profileNavVC.tabBarItem = profileControllerItem
        
        
        let accountSwitchVC = AppNavigator.shared.getAccountSwitchVC(WithUserInfo: user, loggedInUsers: userArray)
        let accountSwitchItem = UITabBarItem(title: "Accounts", image: UIImage(named: "switch_normal"), selectedImage: UIImage(named: "switch_Pressed"))

        let accountSwitchNavVC = UINavigationController(rootViewController: accountSwitchVC)

        
        accountSwitchNavVC.tabBarItem = accountSwitchItem
        
        
        self.viewControllers = [profileNavVC, accountSwitchNavVC]
    }
    
    
    
    
    func changeTabBar(Toindex index: UInt) {
        self.selectedIndex = Int(index)
    }

    func currentTabIndex() -> Int {
        return self.selectedIndex
    }
    
    
    
}
