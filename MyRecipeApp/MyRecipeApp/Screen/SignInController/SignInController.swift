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
  
  // MARK: - Properties
  
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
    setupTextFields()
  }
  
  func setupTextFields() {
    self.emailTextField.delegate = self
    self.passwordTextField.delegate = self
  }
}

// MARK: - Events
extension SignInController {}

// MARK: - UITextFieldDelegate
extension SignInController: UITextFieldDelegate {
  func textFieldShouldReturn(
    _ textField: UITextField
  ) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      // Should auto tap sign in button 
    }
    return true
  }
}
