//
//  RecipeCell.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class RecipeCell: UITableViewCell {
  
  // MARK: - IBOutlet
  @IBOutlet weak var recipeImageView: UIImageView!
  @IBOutlet weak var recipeNameLabel: UILabel!
  
  // MARK: - Properties
  var viewModel: RecipeViewModelProtocol! {
    didSet {
      update()
    }
  }
  
  // MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}

// MARK: - Setups
private extension RecipeCell {
  func update() {
    recipeNameLabel.text = viewModel.name
  }
}
