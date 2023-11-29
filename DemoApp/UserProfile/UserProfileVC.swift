//
//  UserProfileVC.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import UIKit
import SDWebImage

class UserProfileVC: UIViewController {
    
    enum UserProfileOption {
        case NAME
        case EMAIL
        case COMPANY_NAME
    }
    
    struct UserProfileOptionItem {
        let title: String
        let description: String?
        let option: UserProfileOption
        
        static func getItem(ForOption option: UserProfileOption, userInfo: UserInfo) -> UserProfileOptionItem {
            
            switch option {
            case .NAME:
                return UserProfileOptionItem(title: "Name", description: userInfo.name, option: .NAME)
            case .EMAIL:
                return UserProfileOptionItem(title: "Email", description: userInfo.email, option: .EMAIL)
            case .COMPANY_NAME:
                return UserProfileOptionItem(title: "Company Name", description: userInfo.companyName, option: .COMPANY_NAME)
            }
        }
        
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet internal var networkView: NetworkCnnectionDisplayView!
    
    @IBOutlet internal var profilePicImageView: UIImageView!
    @IBOutlet internal var profilePicActivityView: UIActivityIndicatorView!
    @IBOutlet internal var tableView: UITableView!
    
    @IBOutlet internal var logOutButton: UIButton!
    
    //MARK: - Properties
    var userInfo: UserInfo
    
    var profileOptions = [UserProfileOption]() {
        didSet {
            self.profileOptionItems = self.profileOptions.map { UserProfileOptionItem.getItem(ForOption: $0, userInfo: userInfo) }
        }
    }
    
    var profileOptionItems = [UserProfileOptionItem]() {
        
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
    }
    
    //MARK: - Initilization
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(nibName: "UserProfileVC", bundle: .main)
    }
    
    init?(coder: NSCoder, userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    deinit {
        debugPrint("UserProfileVC deinitialize")
    }
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViews()
        self.profileOptions = [.NAME, .EMAIL, .COMPANY_NAME]
        
    }
    
    //MARK: - Set Up Views
    
    internal func setUpViews() {
        setUpProfilePicView()
        setUpTableView()
        setUpButtons()
        setUpNavBar()
    }
    
    internal func setUpNavBar() {
        self.navigationItem.title = "Profile"
    }
    
    internal func setUpProfilePicView() {
        self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.bounds.size.width / 2
        self.profilePicImageView.image = DefaultIcons.PERSON
        
        self.profilePicActivityView.hidesWhenStopped = true
        
        guard let imagePath = userInfo.imagePath, imagePath.count > 0, let url = URL(string: imagePath) else {
            return
        }
        
        SDWebImageManager.shared.loadImage(with: url, options: .highPriority) { [weak self] received, expected, targetURL in
            DispatchQueue.main.async { [weak self] in
                self?.profilePicActivityView.startAnimating()
            }
            
        } completed: { [weak self] image, data, error, cacheType, finished, imageURL in
            
            self?.profilePicActivityView.stopAnimating()
            
            guard let img = image else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.profilePicImageView.image = img
            }
        }
    }
    
    internal func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "UserProfileTableCell", bundle: .main), forCellReuseIdentifier: "UserProfileTableCell")
    }
    
    internal func setUpButtons() {
        self.logOutButton.layer.cornerRadius = self.logOutButton.bounds.size.height / 2
    }
    
    //MARK: - IBActions
    
    @IBAction internal func logOutAction(_ sender: UIButton) {
        let okAction = UIAlertAction(title: "YES", style: .destructive) { action in
            let success = UserAccountService.removeLoggedUsers()
            
            if success {
                UIUtility.showAlert(WithTitle: nil, ofMessage: "Logged Out", style: .alert, withButtonActions: [UIUtility.getCancelAction(WithTitle: "Cancel")], fromViewController: self, sourceView: nil, sourceRect: .zero)
            } else {
                UIUtility.showAlert(WithTitle: "Sorry!!!", ofMessage: "Failed to log out from all account. Please try again", style: .alert, withButtonActions: [UIUtility.getCancelAction(WithTitle: "Cancel")], fromViewController: self, sourceView: nil, sourceRect: .zero)
            }
            
        }
        
        UIUtility.showAlert(WithTitle: "Log out from all accounts", ofMessage: "Are you sure?", style: .alert, withButtonActions: [UIUtility.getCancelAction(WithTitle: "Cancel"), okAction], fromViewController: self, sourceView: nil, sourceRect: .zero)
        
    }
    
}

extension UserProfileVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileOptionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableCell", for: indexPath) as? UserProfileTableCell else {
            return UITableViewCell()
        }
        
        let item = self.profileOptionItems[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Profile Information"
    }
    
}
