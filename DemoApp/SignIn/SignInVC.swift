//
//  SignInVC.swift
//  DemoApp
//
//  Created by Bul on 25/11/23.
//

import UIKit

class SignInVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet internal var profielPicImageView: UIImageView!
    @IBOutlet internal var emailLabel: UILabel!
    @IBOutlet internal var passwordTextField: UITextField!
    
    @IBOutlet internal var signInButton: UIButton!

    let userInfo: UserInfo
    
    var viewModel: SignInViewModel?
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        
        super.init(nibName: "SignInVC", bundle: .main)
    }
    
    init?(coder: NSCoder, userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
    }
    
    internal func setUpViewModel() {
        self.viewModel = SignInViewModel(delegate: self, signInService: SignInService())
    }
    
    internal func setUpViews() {
        setUpEmailLabel()
        setUpPasswordTextField()
    }
    
    internal func setUpEmailLabel() {
        self.emailLabel.text = userInfo.email
    }
    
    internal func setUpPasswordTextField() {
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.delegate = self
    }

    internal func setUpProfileImageView() {
        self.profielPicImageView.image = DefaultIcons.PERSON
    }
    
    internal func setUpSignInButton() {
        self.signInButton.layer.cornerRadius = self.signInButton.bounds.size.height / 2

    }
    
    //MARK: - IBActions
    @IBAction internal func signInButtonAction(_ sender: UIButton) {
        
        guard let tempViewModel = self.viewModel else {
            return
        }
        
        
        guard let pass = self.passwordTextField.text, pass.count > 0 else {
            UIUtility.showAlert(ForTitle: "Sorry!!!", message: "Password is empty", cancelButtonTitle: "Ok", fromViewController: self)

            return
        }
        
        self.signInButton.isEnabled = false
        
        let success = self.viewModel?.singIn(WithUserID: userInfo.userID, password: pass)
        
        self.signInButton.isEnabled = true
        
        if success == false {
            UIUtility.showAlert(ForTitle: "Sign in failed", message: "", cancelButtonTitle: "Ok", fromViewController: self)
            return
        }        
    }
    
}


extension SignInVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -100
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}

extension SignInVC : SignInViewModelDelegateProtocol {
    
}
