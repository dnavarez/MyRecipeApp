//
//  AddRecipeViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation
import FirebaseAuth

protocol AddRecipeViewModelProtocol {
  var recipeVM: RecipeViewModelProtocol { get set }
  
  func postRecipe(
    completion: @escaping (Result<RecipeModel?, ValidationError>) -> Void
  )
}

final class AddRecipeViewModel: AddRecipeViewModelProtocol {
  var recipeVM: RecipeViewModelProtocol
  private var firestoreServices: FirestoreServicesProtocol
  
  init(
    firestoreServices: FirestoreServicesProtocol
  ) {
    self.firestoreServices = firestoreServices
    
    let model = RecipeModel(
      title: "",
      ingredients: [],
      instruction: "",
      ownerId: Auth.auth().currentUser?.uid ?? ""
    )
    
    recipeVM = RecipeViewModel(model: model)
  }
}

// MARK: - Firebase
extension AddRecipeViewModel {
  func postRecipe(
    completion: @escaping (Result<RecipeModel?, ValidationError>) -> Void
  ) {
    let ingredientModels = recipeVM.ingredients.map({
      IngredientModel(name: $0.name, quantity: $0.quantity)
    })
    
    let model = RecipeModel(
      title: recipeVM.name,
      ingredients: ingredientModels,
      instruction: recipeVM.instruction,
      ownerId: recipeVM.ownerId
    )
    
    firestoreServices.postRecipe(with: model) { result in
      switch result {
      case .success(let model):
        completion(.success(model))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
