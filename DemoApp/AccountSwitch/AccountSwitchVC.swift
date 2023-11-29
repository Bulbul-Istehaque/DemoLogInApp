//
//  AccountSwitchVC.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import UIKit
import SDWebImage

class AccountSwitchVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet internal var networkView: NetworkCnnectionDisplayView!
    
    @IBOutlet internal var profileView: UIView!
    @IBOutlet internal var profileImageView: UIImageView!
    @IBOutlet internal var profileNameLabel: UILabel!
    @IBOutlet internal var profileEmailLabel: UILabel!
    
    @IBOutlet internal var tableView: UITableView!
    
    @IBOutlet internal var addAccountButton: UIButton!
    
    //MARK: - Properties
    var currentUserInfo: UserInfo
    
    var loggedInUserInfo: [UserInfo] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.tableView.reloadData()
            }
        }
    }
    
    init(currentUserInfo: UserInfo, loggedInUserInfo: [UserInfo]) {
        self.currentUserInfo = currentUserInfo
        self.loggedInUserInfo = loggedInUserInfo.filter {
            return $0.userID != currentUserInfo.userID
        }
        
        super.init(nibName: "AccountSwitchVC", bundle: .main)
    }
    
    init?(coder: NSCoder, currentUserInfo: UserInfo, loggedInUserInfo: [UserInfo]) {
        self.currentUserInfo = currentUserInfo
        self.loggedInUserInfo = loggedInUserInfo
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    deinit {
        debugPrint("AccountSwitchVC deinitialize")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
    }

    internal func setUpViews() {
        setUpCurrentAccountViews()
        setUpTableView()
        setUpAddAccountButton()
        setUpNavBar()
    }
    
    internal func setUpNavBar() {
        self.navigationItem.title = "Accounts"
    }
    
    internal func setUpCurrentAccountViews() {
        self.profileNameLabel.text = self.currentUserInfo.name
        self.profileEmailLabel.text = self.currentUserInfo.email
        self.profileImageView.image = DefaultIcons.PERSON
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        
        guard let imagePath = currentUserInfo.imagePath, let url = URL(string: imagePath) else { return }
        
        SDWebImageManager.shared.loadImage(with: url, options: .highPriority) { [weak self] received, expected, targetURL in
            
        } completed: { [weak self] image, data, error, cacheType, finished, imageURL in
            
            guard let img = image else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.profileImageView.image = img
            }
        }
        
    }
    
    internal func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AccountSwitchCell", bundle: .main), forCellReuseIdentifier: "AccountSwitchCell")
    }
    
    internal func setUpAddAccountButton() {
        self.addAccountButton.layer.cornerRadius = self.addAccountButton.bounds.height / 2
    }
    
    //MARK: - IBAction
    @IBAction private func addActionAction(_ sender : UIButton) {
        
        guard let navVC = self.navigationController else { return }
        
        AppNavigator.shared.pushLogInVC(InNavigationController: navVC)
    }
    

}

extension AccountSwitchVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loggedInUserInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSwitchCell", for: indexPath) as? AccountSwitchCell else {
            return UITableViewCell()
        }
        
        let userInfo = loggedInUserInfo[indexPath.row]
        
        cell.profileEmailLabel.text = userInfo.email
        
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.bounds.size.width / 2
        
        cell.logOutPressed = { [weak self] in
            // Use weak reference, otherwise retain cycle will occur
            guard let weakSelf = self else { return }
            
            let okAction = UIAlertAction(title: "Yes", style: .destructive) { action in
                let success = UserAccountService.removeUserInfo(userInfo)
                
                if success == false {
                    UIUtility.showAlert(WithTitle: "Log out failed", ofMessage: nil, style: .alert, withButtonActions: [UIUtility.getCancelAction(WithTitle: "Ok")], fromViewController: weakSelf, sourceView: nil, sourceRect: .zero)
                    return
                }
                
                weakSelf.loggedInUserInfo = UserAccountService.loggedInUsers().filter {
                    return $0.userID != weakSelf.currentUserInfo.userID
                }
                
                UIUtility.showAlert(WithTitle: "Logged Out", ofMessage: nil, style: .alert, withButtonActions: [UIUtility.getCancelAction(WithTitle: "Ok")], fromViewController: weakSelf, sourceView: nil, sourceRect: .zero)
            }
            
            UIUtility.showAlert(WithTitle: "Log out from this account", ofMessage: "Are you sure?", style: .alert, withButtonActions: [UIUtility.getCancelAction(WithTitle: "Cancel"), okAction], fromViewController: weakSelf, sourceView: nil, sourceRect: .zero)
        }
        
        guard let imagePath = userInfo.imagePath, let url = URL(string: imagePath) else { return cell }
        
        cell.imagePath = imagePath
        
        SDWebImageManager.shared.loadImage(with: url, options: .highPriority) { received, expected, targetURL in
            
        } completed: { [weak cell] image, data, error, cacheType, finished, imageURL in
            
            guard let tempCell = cell, let img = image, let tempURL = imageURL, tempCell.imagePath == tempURL.absoluteString else {
                return
            }
            DispatchQueue.main.async {
                tempCell.profileImageView.image = img
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0;
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return loggedInUserInfo.count > 0 ? "Accounts" : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            let userInfo = self.loggedInUserInfo[indexPath.row]
            
            UserAccountService.setSignInUser(userInfo.userID)
            
            AppManager.shared.appState = .LOGGED_IN
        }
        
        UIUtility.showAlert(WithTitle: "Switch account", ofMessage: "Are you sure?", style: .alert, withButtonActions: [UIUtility.getCancelAction(WithTitle: "Cancel"), okAction], fromViewController: self, sourceView: nil, sourceRect: .zero)
    }
    
}
