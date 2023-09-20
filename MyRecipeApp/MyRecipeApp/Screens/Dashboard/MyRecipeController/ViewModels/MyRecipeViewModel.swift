//
//  MyRecipeViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/20/23.
//

import Foundation

protocol MyRecipeViewModelProtocol {
  var items: [RecipeViewModelProtocol] { get }
  
  func fetchRecipes(
    completion: @escaping (Result<[RecipeModel?], ValidationError>) -> Void
  )
}

final class MyRecipeViewModel: MyRecipeViewModelProtocol {
  private var recipes: [RecipeModel] = []
  private var firestoreServices: FirestoreServicesProtocol
  
  init(
    firestoreServices: FirestoreServicesProtocol
  ) {
    self.firestoreServices = firestoreServices
  }
}

// MARK: - Firebase
extension MyRecipeViewModel {
  func fetchRecipes(
    completion: @escaping (Result<[RecipeModel?], ValidationError>) -> Void
  ) {
    firestoreServices.getMyRecipies { [weak self] result in
      switch result {
      case .success(let recipes):
        self?.recipes = recipes
        completion(.success(recipes))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

// MARK: - Getters
extension MyRecipeViewModel {
  var items: [RecipeViewModelProtocol]{
    let vms = recipes.map({ RecipeViewModel(model: $0) })
    return vms
  }
}

