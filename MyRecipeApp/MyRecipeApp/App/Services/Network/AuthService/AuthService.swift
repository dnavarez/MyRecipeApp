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
  func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Result<User?, ValidationError>) -> Void)
}

final class AuthService: AuthServiceProtocol {
  init() {}
}

extension AuthService {
  func registerUser(
    with userRequest: RegisterUserRequest,
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
      
      // If no error, we're saving the email and password in firestore under users and uid (user id)
      let db = Firestore.firestore()
      db.collection("users")
        .document(resultUser.uid)
        .setData([
          "email": email
        ]) { error in
          if let error = error {
            completion(.failure(.other(message: error.localizedDescription)))
            return
          }
          
          completion(.success(resultUser))
        }
    }
  }
  
  
  func LoginUser(
    with userRequest: LoginUserRequest,
    completion: @escaping (Result<String, ValidationError>) -> Void
  ) {
    Auth.auth().signIn(
      withEmail: userRequest.email,
      password: userRequest.password
    ) { result, error in
      
    }
  }
}
