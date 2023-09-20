//
//  RecipeViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation

protocol RecipeViewModelProtocol {
  var name: String { get set }
  var ingredients: [IngredientViewModelProtocol] { get set }
  var instruction: String { get set }
  var ownerId: String { get set }
}

final class RecipeViewModel: RecipeViewModelProtocol {
  var name: String = ""
  var ingredients: [IngredientViewModelProtocol] = []
  var instruction: String = ""
  var ownerId: String = ""
  
  init(model: RecipeModel) {
    self.name = model.title
    self.ingredients = model.ingredients.map({ IngredientViewModel(model: $0) })
    self.instruction = model.instruction
    self.ownerId = model.ownerId
  }
}
