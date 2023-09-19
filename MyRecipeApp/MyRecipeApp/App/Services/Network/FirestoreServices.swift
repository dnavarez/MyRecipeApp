//
//  FirestoreServices.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/20/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol FirestoreServicesProtocol {
  /// A method to register the user
  /// - Parameters:
  ///   - completion: A completion with success or failure response
  func getRecipies(completion: @escaping (Result<[RecipeModel], ValidationError>) -> Void)
  
  /// A method to register the user
  /// - Parameters:
  ///   - userRequest: The user information (email and password)
  ///   - completion: A completion with success or failure response
  func postRecipe(with model: RecipeModel, completion: @escaping (Result<RecipeModel?, ValidationError>) -> Void)
}

final class FirestoreServices: FirestoreServicesProtocol {
  private let db: Firestore
  
  init() {
    db = Firestore.firestore()
  }
}

extension FirestoreServices {
  func getRecipies(completion: @escaping (Result<[RecipeModel], ValidationError>) -> Void) {
    guard let currentUser = Auth.auth().currentUser
    else {
      return completion(.failure(.other(message: ValidationError.unknownError.localizedDescription)))
    }
    
    db.collection("users")
      .document(currentUser.uid)
      .collection("recipes")
      .getDocuments{ snapshot, error in
        guard let documents = snapshot?.documents, error == nil else {
          completion(.failure(.other(message: error?.localizedDescription ?? ValidationError.unknownError.localizedDescription)))
          return
        }
        
        var models: [RecipeModel] = []
        
        for document in documents {
          let data = document.data()
          
          guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
            print("Something is wrong while converting dictionary to JSON data.")
            return
          }
          
          do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let recipeModel = try decoder.decode(RecipeModel.self, from: jsonData)
            models.append(recipeModel)
          } catch{}
        }
        
        completion(.success(models))
      }
  }
  
  func postRecipe(
    with model: RecipeModel,
    completion: @escaping (Result<RecipeModel?, ValidationError>) -> Void
  ) {
    guard let currentUser = Auth.auth().currentUser
    else {
      return completion(.failure(.other(message: ValidationError.unknownError.localizedDescription)))
    }
    
    let ingredients = model.ingredients.map({
      [
        "name": $0.name,
        "quantity": $0.quantity
      ]
    })
    
    db.collection("users")
      .document(currentUser.uid)
      .collection("recipes")
      .document()
      .setData([
        "title": model.title,
        "ingredients": ingredients,
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

