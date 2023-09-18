//
//  RegisterController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import UIKit

class RegisterController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  
  @IBOutlet private weak var signUpButton: UIButton!
  
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
    // TODO: Should call register api
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
