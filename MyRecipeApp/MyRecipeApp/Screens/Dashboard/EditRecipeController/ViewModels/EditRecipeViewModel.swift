//
//  EditRecipeViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/20/23.
//

import Foundation
import FirebaseAuth

protocol EditRecipeViewModelProtocol {
  var recipeVM: RecipeViewModelProtocol { get set }
  
  func updateRecipe(
    completion: @escaping (Result<RecipeModel?, ValidationError>) -> Void
  )
}

final class EditRecipeViewModel: EditRecipeViewModelProtocol {
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
extension EditRecipeViewModel {
  func updateRecipe(
    completion: @escaping (Result<RecipeModel?, ValidationError>) -> Void
  ) {
    let ingredientModels = recipeVM.ingredients.map({
      IngredientModel(name: $0.name, quantity: $0.quantity)
    })
    
    let model = RecipeModel(
      id: recipeVM.id,
      title: recipeVM.name,
      ingredients: ingredientModels,
      instruction: recipeVM.instruction,
      ownerId: recipeVM.ownerId
    )
    
    firestoreServices.putRecipe(with: model) { result in
      switch result {
      case .success(let model):
        completion(.success(model))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

