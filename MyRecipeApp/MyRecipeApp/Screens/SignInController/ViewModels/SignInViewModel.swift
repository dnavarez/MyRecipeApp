//
//  SignInViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import Foundation

protocol SignInViewModelProtocol {
  func validate(email: String?, password: String?) -> ValidationError?
  func login(email: String, password: String, completion: @escaping (Result<Void, ValidationError>) -> Void)
}

final class SignInViewModel: SignInViewModelProtocol {
  private var authService: AuthServiceProtocol
  
  init(
    authService: AuthServiceProtocol
  ) {
    self.authService = authService
  }
}

extension SignInViewModel {
  func validate(
    email: String?,
    password: String?
  ) -> ValidationError? {
    guard let email = email, email.isValidEmail else {
      return .invalidEmail
    }
    
    if email.isEmpty {
      return .emptyEmail
    }
    
    guard let password = password else {
      return .invalidEmail
    }
    
    if password.isEmpty {
      return .emptyPassword
    }
    
    return nil
  }
  
  func login(
    email: String,
    password: String,
    completion: @escaping (Result<Void, ValidationError>) -> Void
  ) {
    let userRequestParam = LoginUserRequest(email: email, password: password)
    authService.loginUser(
      with: userRequestParam
    ) { result in
      switch result {
      case .success(_):
        completion(.success(()))
      case .failure(let error):
        completion(.failure(.other(message: error.localizedDescription)))
      }
    }
  }
}
