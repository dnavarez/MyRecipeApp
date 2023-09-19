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
  private var createService: CreateServiceProtocol
  
  init(
    createService: CreateServiceProtocol
  ) {
    self.createService = createService
    recipeVM = RecipeViewModel(model: RecipeModel(name: "", ingredients: [], instruction: ""))
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
      name: recipeVM.name,
      ingredients: ingredientModels,
      instruction: recipeVM.instruction
    )
    
    createService.postRecipe(with: model) { result in
      switch result {
      case .success(let model):
        completion(.success(model))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
