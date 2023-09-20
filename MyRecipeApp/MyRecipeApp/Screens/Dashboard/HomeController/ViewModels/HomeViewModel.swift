//
//  HomeViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/20/23.
//

import Foundation

protocol HomeViewModelProtocol {
  var items: [RecipeViewModelProtocol] { get }
  
  func fetchRecipes(
    completion: @escaping (Result<[RecipeModel?], ValidationError>) -> Void
  )
}

final class HomeViewModel: HomeViewModelProtocol {
  private var recipes: [RecipeModel] = []
  private var firestoreServices: FirestoreServicesProtocol
  
  init(
    firestoreServices: FirestoreServicesProtocol
  ) {
    self.firestoreServices = firestoreServices
  }
}

// MARK: - Firebase
extension HomeViewModel {
  func fetchRecipes(
    completion: @escaping (Result<[RecipeModel?], ValidationError>) -> Void
  ) {
    firestoreServices.getAllRecipies { [weak self] result in
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
extension HomeViewModel {
  var items: [RecipeViewModelProtocol]{
    let vms = recipes.map({ RecipeViewModel(model: $0) })
    return vms
  }
}
