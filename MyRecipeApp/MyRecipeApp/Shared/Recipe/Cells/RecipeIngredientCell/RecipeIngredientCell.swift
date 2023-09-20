//
//  RecipeIngredientCell.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class RecipeIngredientCell: UITableViewCell {
  var viewModel: IngredientViewModelProtocol! {
    didSet {
      update()
    }
  }
  
  // MARK: - IBOutlet
  @IBOutlet weak var ingredientNameLabel: UILabel!
  @IBOutlet weak var ingredientQuantityLabel: UILabel!
  
  // MARK: - Properties
  
  // MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    ingredientNameLabel.text = ""
    ingredientQuantityLabel.text = ""
  }
}

// MARK: - Setups
private extension RecipeIngredientCell {
  func update() {
    ingredientNameLabel.text = viewModel.name
    ingredientQuantityLabel.text = viewModel.quantity
  }
}

