//
//  MyRecipeCell.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class MyRecipeCell: UITableViewCell {
  
  // MARK: - IBOutlet
  @IBOutlet weak var recipeImageView: UIImageView!
  @IBOutlet weak var recipeNameLabel: UILabel!
  
  // MARK: - Properties
  
  // MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
}

// MARK: - Setups
private extension RecipeCell {
  func setups() {}
}
