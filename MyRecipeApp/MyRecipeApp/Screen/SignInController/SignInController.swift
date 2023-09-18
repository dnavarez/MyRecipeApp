//
//  SignInController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import UIKit

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
    viewModel.login(
      email: emailTextField.text,
      password: passwordTextField.text) { [weak self] result in
        switch result {
        case .success(let success):
          // TODO: - Proceed to Dashboard
          print("success")
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
  }
  
  @IBAction func signUpButtonTapped(_ sender: Any) {
    guard let vc = R.storyboard.register.registerController() else { return }
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
