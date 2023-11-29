//
//  LogInVC.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import UIKit
import ProgressHUD

class LogInVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet internal var networkView: NetworkCnnectionDisplayView!
    
    @IBOutlet internal var emailView: UIView!
    @IBOutlet internal var emailLabel: UILabel!
    @IBOutlet internal var emailTextField: UITextField!
    
    @IBOutlet internal var passwordView: UIView!
    @IBOutlet internal var passwordLabel: UILabel!
    @IBOutlet internal var passwordTextField: UITextField!
    
    @IBOutlet internal var logInButton: UIButton!
    
        
    //MARK: - Properties
    
    var viewModel: LogInViewModel?
    
    deinit {
        debugPrint("LogInVC deinitialize")
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewModel()
        setUpViews()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up Views
    
    internal func setUpViewModel() {
        viewModel = LogInViewModel(delegate: self, signInService: LogInNetworkService())
    }
    
    internal func setUpViews() {
        setUpEmailViews()
        setUpPasswordViews()
        setUpSignInButton()
        setUpNavBar()
    }
    
    internal func setUpNavBar() {
        self.navigationItem.title = "Log In"
    }
    
    internal func setUpEmailViews() {
        self.emailTextField.delegate = self
        self.emailTextField.layer.cornerRadius = 10.0
        self.emailTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        self.emailTextField.layer.borderWidth = 1.0
        self.emailTextField.setLeftPaddingPoints(10)
        self.emailTextField.setRightPaddingPoints(10)
        UIUtility.addDoneButtonOnKeyboard(self, action: #selector(self.toolbarDoneAction), textField: self.emailTextField)
    }
    
    internal func setUpPasswordViews() {
        self.passwordTextField.delegate = self
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.layer.cornerRadius = 10.0
        self.passwordTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        self.passwordTextField.layer.borderWidth = 1.0
        self.passwordTextField.setLeftPaddingPoints(10)
        self.passwordTextField.setRightPaddingPoints(10)
        UIUtility.addDoneButtonOnKeyboard(self, action: #selector(self.toolbarDoneAction), textField: self.passwordTextField)
    }
    
    internal func setUpSignInButton() {
        self.logInButton.layer.cornerRadius = self.logInButton.bounds.size.height / 2
    }

    
    //MARK: - IBActions
    @IBAction internal func logInButtonAction(_ sender: UIButton) {
        
        guard let tempViewModel = self.viewModel else {
            return
        }
        
        guard let email = self.emailTextField.text, email.count > 0 else {
            UIUtility.showAlert(ForTitle: "Sorry!!!", message: "Email is empty", cancelButtonTitle: "Ok", fromViewController: self)
            return
        }
        
        guard let pass = self.passwordTextField.text, pass.count > 0 else {
            UIUtility.showAlert(ForTitle: "Sorry!!!", message: "Password is empty", cancelButtonTitle: "Ok", fromViewController: self)

            return
        }
        
        toolbarDoneAction()
        
        self.logInButton.isEnabled = false
        
        ProgressHUD.show("Please wait...", interaction: false)
        
        tempViewModel.logIn(WithEmail: email, password: pass, { [weak self] success, errorReason in
            
            guard let weakSelf = self else { return }
            
            ProgressHUD.dismiss()
            
            DispatchQueue.main.async {
                weakSelf.logInButton.isEnabled = true
            }
            
            if let err = errorReason {
                
                UIUtility.showAlert(ForTitle: "Log in failed", message: err, cancelButtonTitle: "Ok", fromViewController: weakSelf)
                return
            }
            
            if success == false {
                UIUtility.showAlert(ForTitle: "Log in failed", message: errorReason ?? "", cancelButtonTitle: "Ok", fromViewController: weakSelf)
                return
            }
                        
            UIUtility.showAlert(ForTitle: "Log in successful", message: nil, cancelButtonTitle: "Ok", fromViewController: weakSelf)
        })
        
    }
    
    @objc internal func toolbarDoneAction() {
        if self.emailTextField.isFirstResponder {
            self.emailTextField.resignFirstResponder()
            return
        }
        
        if self.passwordTextField.isFirstResponder {
            self.passwordTextField.resignFirstResponder()
            return
        }
    }
    

}

extension LogInVC: LogInViewModelDelegateProtocol {
    
}


extension LogInVC : UITextFieldDelegate {
    
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
