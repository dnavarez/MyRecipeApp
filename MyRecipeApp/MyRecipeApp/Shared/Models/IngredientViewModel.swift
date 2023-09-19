//
//  IngredientViewModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation

protocol IngredientViewModelProtocol {
  var name: String { get set }
  var quantity: String { get set }
}

final class IngredientViewModel: IngredientViewModelProtocol {
  var name: String = ""
  var quantity: String = ""
  
  init(model: IngredientModel) {
    self.name = model.name
    self.quantity = model.quantity
  }
}
