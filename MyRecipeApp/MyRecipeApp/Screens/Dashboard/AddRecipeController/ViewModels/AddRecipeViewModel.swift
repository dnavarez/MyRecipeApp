//
//  AddRecipeViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation

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
    recipeVM = RecipeViewModel(model: RecipeModel(title: "", ingredients: [], instruction: ""))
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
      instruction: recipeVM.instruction
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
