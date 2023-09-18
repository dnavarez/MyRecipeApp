//
//  SignInViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import Foundation

protocol SignInViewModelProtocol {
  func login(email: String?, password: String?, result: @escaping (Result<Void, ValidationError>) -> Void)
}

final class SignInViewModel: SignInViewModelProtocol {
  init() {
    
  }
}

extension SignInViewModel {
  func login(
    email: String?,
    password: String?,
    result: @escaping (Result<Void, ValidationError>) -> Void
  ) {
    guard let email = email, email.isValidEmail else {
      return result(.failure(.invalidEmail))
    }
    
    if email.isEmpty {
      return result(.failure(.emptyEmail))
    }
    
    guard let password = password else {
      return result(.failure(.invalidEmail))
    }
    
    if password.isEmpty {
      return result(.failure(.emptyPassword))
    }
    
    // TODO: - Call login api
  }
}
