//
//  RegisterController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import UIKit
import SVProgressHUD

class RegisterController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  
  @IBOutlet private weak var signUpButton: UIButton!
  
  // MARK: - Properties
  var viewModel: RegisterViewModel!
  
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
extension RegisterController {
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
extension RegisterController {
  @IBAction func signUpButtonTapped(_ sender: Any) {
    SVProgressHUD.show()
    
    if let errorResult = viewModel.validate(email: emailTextField.text, password: passwordTextField.text) {
      SVProgressHUD.showError(withStatus: errorResult.localizedDescription)
    }
    
    if let email = emailTextField.text,
       let password = passwordTextField.text {
      viewModel.register(
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
  
  @IBAction func signInButtonTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UITextFieldDelegate
extension RegisterController: UITextFieldDelegate {
  func textFieldShouldReturn(
    _ textField: UITextField
  ) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      // Should auto tap sign up button
      signUpButton.sendActions(for: .touchUpInside)
    }
    return true
  }
}
