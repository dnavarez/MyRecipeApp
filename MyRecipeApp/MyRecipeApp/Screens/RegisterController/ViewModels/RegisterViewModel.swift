//
//  RegisterViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import Foundation

protocol RegisterViewModelProtocol {
  func validate(email: String?, password: String?) -> ValidationError?
  func register(email: String, password: String, completion: @escaping (Result<Void, ValidationError>) -> Void)
}

final class RegisterViewModel: RegisterViewModelProtocol {
  private var authService: AuthServiceProtocol
  
  init(
    authService: AuthServiceProtocol
  ) {
    self.authService = authService
  }
}

extension RegisterViewModel {
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
  
  func register(
    email: String,
    password: String,
    completion: @escaping (Result<Void, ValidationError>) -> Void
  ) {
    let userRequestParam = UserModel(email: email, password: password)
    authService.registerUser(
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
