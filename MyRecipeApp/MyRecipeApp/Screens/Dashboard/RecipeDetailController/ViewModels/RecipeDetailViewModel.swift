//
//  RecipeDetailViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/20/23.
//

import Foundation
import FirebaseAuth

protocol RecipeDetailViewModelProtocol {
  var recipeVM: RecipeViewModelProtocol { get set }
  
  func deleteRecipe(
    completion: @escaping (Result<Void, ValidationError>) -> Void
  )
}

final class RecipeDetailViewModel: RecipeDetailViewModelProtocol {
  var recipeVM: RecipeViewModelProtocol
  private var firestoreServices: FirestoreServicesProtocol
  
  init(
    recipeVM: RecipeViewModelProtocol,
    firestoreServices: FirestoreServicesProtocol
  ) {
    self.firestoreServices = firestoreServices
    self.recipeVM = recipeVM
  }
}

// MARK: - Firebase
extension RecipeDetailViewModel {
  func deleteRecipe(
    completion: @escaping (Result<Void, ValidationError>) -> Void
  ) {
    guard let docId = recipeVM.id
    else {
      completion(.failure(.other(message: "Invalid recipe id")))
      return
    }
    
    firestoreServices.deleteRecipe(with: docId) { result in
      switch result {
      case .success(_):
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}


