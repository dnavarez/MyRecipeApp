//
//  RecipeHeaderView.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class RecipeHeaderView: UIView {
  
  // MARK: - IBOutlet
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addButton: UIButton!
  
  // MARK: - Properties
  var onAddIngredient: (() -> Void)?
}

// MARK: - Events
private extension RecipeHeaderView {
  @IBAction func addButtonTapped(_ sender: Any) {
    onAddIngredient?()
  }
}
