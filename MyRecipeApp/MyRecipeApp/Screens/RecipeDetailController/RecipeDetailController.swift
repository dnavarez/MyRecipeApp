//
//  RecipeController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit
import SVProgressHUD

class RecipeDetailController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var recipeImageView: UIImageView!
  
  // MARK: - Properties
  var viewModel: RecipeViewModelProtocol!
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setups()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
}

// MARK: - Setups
private extension RecipeDetailController {
  func setups() {
    setupNavigationBar()
    setupTableView()
  }
  
  func setupNavigationBar() {
    navigationItem.title = "Recipe"
    
    let backBtn = UIBarButtonItem(
      image: R.image.iconBack(),
      style: .done,
      target: self,
      action: #selector(didTapBack)
    )
    navigationItem.leftBarButtonItem = backBtn
  }
  
  func setupTableView() {
    tableView.addPadding()
    tableView.registerCells(
      nibs: [
        R.nib.recipeTitleCell,
        R.nib.recipeIngredientCell,
        R.nib.recipeInstructionCell,
        R.nib.recipeEmptyCell
      ])
  }
}

// MARK: - Methods
private extension RecipeDetailController {}

// MARK: - Events
private extension RecipeDetailController {
  @objc
  func didTapBack() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - Delegates
extension RecipeDetailController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(
    in tableView: UITableView
  ) -> Int {
    // We only have 3 sections (Recipe name, Ingredients and Instruction)
    return 3
  }
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    // Return the number of rows for ingredients else return only 1
    return section == 1 ? viewModel.ingredients.count : 1
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    switch indexPath.section {
    case 0: return recipeTitleCell()
    case 1: return ingredientCellAtIndexPath(indexPath)
    case 2: return recipeInstructionCell(indexPath)
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    if section == 0 {
      return nil
    } else {
      guard let headerView = R.nib.recipeHeaderView(withOwner: self)
      else { return nil }
      
      let title = section == 1 ? "Ingredients" : "Instructions"
      headerView.titleLabel.text = title
      headerView.addButton.isHidden = true
      
      return headerView
    }
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    return section == 0 ? 0 : 44
  }
}

// MARK: - Helpers
private extension RecipeDetailController {
  func recipeSectionView(
    with title: String,
    isAddButtonHidden: Bool = true
  ) -> RecipeHeaderView? {
    guard let headerView = R.nib.recipeHeaderView(withOwner: self)
    else { return nil }
    
    headerView.titleLabel.text = title
    headerView.addButton.isHidden = isAddButtonHidden
    
    return headerView
  }
  
  func recipeTitleCell() -> RecipeTitleCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.recipeTitleCell.name
    ) as? RecipeTitleCell
    else { return RecipeTitleCell() }
    
    cell.updateRecipeTitle(viewModel.name)
    
    return cell
  }
  
  func ingredientCellAtIndexPath(
    _ indexPath: IndexPath
  ) -> UITableViewCell {
    let emptyCell = emptyCellWithMessage("No Ingredients added yet.")
    let ingredientCell = recipeIngredientCell(indexPath)
    let cell = viewModel.ingredients.count == 0 ? emptyCell : ingredientCell
    return cell
  }
  
  func recipeIngredientCell(
    _ indexPath: IndexPath
  ) -> RecipeIngredientCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.recipeIngredientCell.name
    ) as? RecipeIngredientCell
    else { return RecipeIngredientCell() }
    
    let vm = viewModel.ingredients[indexPath.row]
    cell.viewModel = vm
    
    return cell
  }
  
  func recipeInstructionCell(
    _ indexPath: IndexPath
  ) -> RecipeInstructionCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.recipeInstructionCell.name
    ) as? RecipeInstructionCell
    else { return RecipeInstructionCell() }
    
    cell.updateRecipeInstruction(viewModel.instruction)
    
    return cell
  }
  
  func emptyCellWithMessage(_ message: String) -> RecipeEmptyCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.recipeEmptyCell.name
    ) as? RecipeEmptyCell
    else { return RecipeEmptyCell() }
    
    cell.messageLabel.text = message
    
    return cell
  }
}
