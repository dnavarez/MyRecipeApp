//
//  RecipeInstructionCell.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class RecipeInstructionCell: UITableViewCell {
  
  // MARK: - IBOutlet
  @IBOutlet weak var instructionLabel: UILabel!
  
  // MARK: - Properties
  var onUpdateRecipeInstruction: (() -> Void)?
  
  // MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    setups()
  }
  
  func updateRecipeInstruction(_ instruction: String) {
    if instruction.isEmpty {
      instructionLabel.text = "Enter instruction here"
    } else {
      instructionLabel.text = instruction
    }
  }
}

// MARK: - Setups
private extension RecipeInstructionCell {
  func setups() {
    setupTapGesture()
  }
  
  func setupTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecipeTitleLabel))
    instructionLabel.addGestureRecognizer(tapGesture)
    instructionLabel.isUserInteractionEnabled = true
  }
}

// MARK: - Events
private extension RecipeInstructionCell {
  @objc
  func didTapRecipeTitleLabel() {
    onUpdateRecipeInstruction?()
  }
}
