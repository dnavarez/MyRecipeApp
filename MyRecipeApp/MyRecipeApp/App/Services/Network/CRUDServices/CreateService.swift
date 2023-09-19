//
//  CreateService.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol CreateServiceProtocol {
  /// A method to register the user
  /// - Parameters:
  ///   - userRequest: The user information (email and password)
  ///   - completion: A completion with success or failure response
  func postRecipe(with model: RecipeModel, completion: @escaping (Result<RecipeModel?, ValidationError>) -> Void)
}

final class CreateService: CreateServiceProtocol {
  init() {}
}

extension CreateService {
  func postRecipe(
    with model: RecipeModel,
    completion: @escaping (Result<RecipeModel?, ValidationError>) -> Void
  ) {
    guard let currentUser = Auth.auth().currentUser
    else {
      return completion(.failure(.other(message: ValidationError.unknownError.localizedDescription)))
    }
    
    let db = Firestore.firestore()
    db.collection("recipes")
      .document(currentUser.uid)
      .setData([
        "title": model.name,
        "ingredients": model.ingredients,
        "instruction": model.instruction
      ]) { error in
        if let error = error {
          completion(.failure(.other(message: error.localizedDescription)))
          return
        }
        
        completion(.success(model))
      }
  }
}

