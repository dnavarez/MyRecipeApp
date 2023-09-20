//
//  RecipeController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class RecipeDetailController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var recipeImageView: UIImageView!
  
  // MARK: - Properties
  var viewModel: RecipeDetailViewModelProtocol!
  
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
    
    if Auth.auth().currentUser?.uid == viewModel.recipeVM.ownerId {
      addRightBarButtons()
    }
  }
  
  func addRightBarButtons() {
    let deleteBtn = UIBarButtonItem(
      image: R.image.iconDelete(),
      style: .done,
      target: self,
      action: #selector(didTapDelete)
    )
    
    let editBtn = UIBarButtonItem(
      image: R.image.iconEdit(),
      style: .done,
      target: self,
      action: #selector(didTapEdit)
    )
  navigationItem.rightBarButtonItems = [editBtn, deleteBtn]
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
private extension RecipeDetailController {
  func deleteRecipe() {
    SVProgressHUD.show()
    
    viewModel.deleteRecipe { [weak self] result in
      guard let self = self else { return }
      SVProgressHUD.dismiss()
      
      switch result {
      case .success():
        SVProgressHUD.showSuccess(withStatus: "Recipe has been successfully deleted.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          SVProgressHUD.dismiss()
          self.navigationController?.popViewController(animated: true)
        }
      case .failure(let error):
        SVProgressHUD.showError(withStatus: error.localizedDescription)
      }
    }
  }
}

// MARK: - Events
private extension RecipeDetailController {
  @objc
  func didTapBack() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc
  func didTapEdit() {
    guard let vc = R.storyboard.editRecipe.editRecipeController() else { return }
    
    let vm = EditRecipeViewModel(
      recipeVM: viewModel.recipeVM,
      firestoreServices: AppDelegate.shared.appServices.firestoreServices
    )
    vc.viewModel = vm
    
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    
    navigationController?.present(nav, animated: true)
  }
  
  @objc
  func didTapDelete() {
    let alertVC = UIAlertController(
      title: "Are you sure you want to delete this recipe?",
      message: nil,
      preferredStyle: .alert
    )
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] _ in
      self?.deleteRecipe()
    })
    
    alertVC.addAction(cancelAction)
    alertVC.addAction(deleteAction)
    
    self.present(alertVC, animated: true)
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
    return section == 1 ? viewModel.recipeVM.ingredients.count : 1
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
    
    cell.updateRecipeTitle(viewModel.recipeVM.name)
    
    return cell
  }
  
  func ingredientCellAtIndexPath(
    _ indexPath: IndexPath
  ) -> UITableViewCell {
    let emptyCell = emptyCellWithMessage("No Ingredients added yet.")
    let ingredientCell = recipeIngredientCell(indexPath)
    let cell = viewModel.recipeVM.ingredients.count == 0 ? emptyCell : ingredientCell
    return cell
  }
  
  func recipeIngredientCell(
    _ indexPath: IndexPath
  ) -> RecipeIngredientCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.recipeIngredientCell.name
    ) as? RecipeIngredientCell
    else { return RecipeIngredientCell() }
    
    let vm = viewModel.recipeVM.ingredients[indexPath.row]
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
    
    cell.updateRecipeInstruction(viewModel.recipeVM.instruction)
    
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
