//
//  SignInController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import UIKit
import SVProgressHUD

class SignInController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  
  @IBOutlet private weak var signInButton: UIButton!
  
  // MARK: - Properties
  var viewModel: SignInViewModel!
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setups()
  }
  
  override func viewWillAppear(
    _ animated: Bool
  ) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
}

// MARK: - Setups
extension SignInController {
  func setups() {
    setupTextFields(emailTextField)
    setupTextFields(passwordTextField)
  }
  
  func setupTextFields(_ textField: UITextField) {
    textField.delegate = self
    textField.addPadding()
  }
}

// MARK: - Events
extension SignInController {
  @IBAction func signInButtonTapped(_ sender: Any) {
    SVProgressHUD.show()
    
    if let errorResult = viewModel.validate(email: emailTextField.text, password: passwordTextField.text) {
      SVProgressHUD.showError(withStatus: errorResult.localizedDescription)
    }
    
    if let email = emailTextField.text,
       let password = passwordTextField.text {
      viewModel.login(
        email: email,
        password: password
      ) { result in
        SVProgressHUD.dismiss()
        switch result {
        case .success(_):
          AppDelegate.shared.updateRootViewController()
        case .failure(let error):
          SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
      }
    }
  }
  
  @IBAction func signUpButtonTapped(_ sender: Any) {
    guard
      let vc = R.storyboard.register.registerController(),
      let appServices = AppDelegate.shared.appServices
    else { return }
    
    let vm = RegisterViewModel(authService: appServices.authService)
    vc.viewModel = vm
    
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - UITextFieldDelegate
extension SignInController: UITextFieldDelegate {
  func textFieldShouldReturn(
    _ textField: UITextField
  ) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      // Should auto tap sign in button
      signInButton.sendActions(for: .touchUpInside)
    }
    return true
  }
}
