//
//  RecipeModel.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation

struct RecipeModel: Codable {
  var id: String? = nil
  let title: String
  let ingredients: [IngredientModel]
  let instruction: String
  let ownerId: String
}
