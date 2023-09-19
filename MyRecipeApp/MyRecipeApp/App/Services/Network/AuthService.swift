//
//  AuthService.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthServiceProtocol {
  /// A method to register the user
  /// - Parameters:
  ///   - userRequest: The user information (email and password)
  ///   - completion: A completion with success or failure response
  func registerUser(with userRequest: UserModel, completion: @escaping (Result<User?, ValidationError>) -> Void)
  
  /// A method to login user
  /// - Parameters:
  ///   - userRequest: The user information (email and password)
  ///   - completion: A completion with success or failure response
  func loginUser(with userRequest: UserModel, completion: @escaping (Result<Void, ValidationError>) -> Void)
}

final class AuthService: AuthServiceProtocol {
  init() {}
}

extension AuthService {
  func registerUser(
    with userRequest: UserModel,
    completion: @escaping (Result<User?, ValidationError>) -> Void
  ) {
    let email = userRequest.email
    let password = userRequest.password
    
    // Create the user
    Auth.auth().createUser(
      withEmail: email,
      password: password
    ) { result, error in
      if let error = error {
        completion(.failure(.other(message: error.localizedDescription)))
        return
      }
      
      guard let resultUser = result?.user
      else {
        return completion(.failure(.other(message: ValidationError.unknownError.localizedDescription)))
      }
      
      completion(.success(resultUser))
    }
  }
  
  func loginUser(
    with userRequest: UserModel,
    completion: @escaping (Result<Void, ValidationError>) -> Void
  ) {
    Auth.auth().signIn(
      withEmail: userRequest.email,
      password: userRequest.password
    ) { result, error in
      if let error = error {
        completion(.failure(.other(message: error.localizedDescription)))
        return
      }
      
      completion(.success(()))
    }
  }
}
