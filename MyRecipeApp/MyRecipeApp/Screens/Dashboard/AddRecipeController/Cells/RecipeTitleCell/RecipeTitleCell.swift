//
//  RecipeTitleCell.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class RecipeTitleCell: UITableViewCell {
  
  // MARK: - @IBOutlet
  @IBOutlet private weak var recipeTitleLabel: UILabel!
  
  // MARK: - Properties
  var onUpdateRecipeTitle: (() -> Void)?
  
  // MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    setups()
  }
  
  func updateRecipeTitle(_ title: String) {
    if title.isEmpty {
      recipeTitleLabel.text = "Enter recipe title here"
    } else {
      recipeTitleLabel.text = title
    }
  }
}

// MARK: - Setups
private extension RecipeTitleCell {
  func setups() {
    setupTapGesture()
  }
  
  func setupTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecipeTitleLabel))
    recipeTitleLabel.addGestureRecognizer(tapGesture)
    recipeTitleLabel.isUserInteractionEnabled = true
  }
}

// MARK: - Events
private extension RecipeTitleCell {
  @objc
  func didTapRecipeTitleLabel() {
    onUpdateRecipeTitle?()
  }
}
