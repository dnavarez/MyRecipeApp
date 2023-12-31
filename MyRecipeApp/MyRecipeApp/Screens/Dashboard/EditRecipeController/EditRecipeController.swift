//
//  EditRecipeController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/20/23.
//

import UIKit
import SVProgressHUD

class EditRecipeController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var recipeImageView: UIImageView!
  @IBOutlet weak var addRecipeImageButton: UIButton!
  
  // MARK: - Properties
  var viewModel: EditRecipeViewModelProtocol!
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setups()
  }
}

// MARK: - Setups
private extension EditRecipeController {
  func setups() {
    setupNavigationBar()
    setupTableView()
  }
  
  func setupNavigationBar() {
    navigationItem.title = "Edit Recipe"
    
    let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveButton))
    saveBtn.isEnabled = false
    navigationItem.rightBarButtonItem = saveBtn
    
    let closeBtn = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(didTapCloseButton))
    navigationItem.leftBarButtonItem = closeBtn
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
private extension EditRecipeController {
  func updateRecipeTitle() {
    let alertTFController = AlertTextFieldController()
    alertTFController.showAlert(
      on: self,
      title: "Update Recipe Title",
      textFieldPlaceHolder: ["Enter recipe name"]
    ) { [weak self] values in
      guard let self = self,
            let text = values.first
      else { return }
      
      self.viewModel.recipeVM.name = text ?? "Unknown recipe name"
      self.tableView.reloadData()
      self.validateSaveButton()
    }
  }
  
  func addIngredient() {
    let alertTFController = AlertTextFieldController()
    alertTFController.showAlert(
      on: self,
      title: "Add Ingredient",
      textFieldPlaceHolder: [
        "Enter ingredient name here",
        "Enter quantity here. (160g or 12pcs)"
      ]
    ) { [weak self] values in
      guard let self = self else { return }
      
      let name = values.first ?? "Unknown ingredient"
      let qty = values.last ?? ""
      
      let model = IngredientModel(
        name: name!,
        quantity: qty!
      )
      
      let vm = IngredientViewModel(model: model)
      
      self.viewModel.recipeVM.ingredients.append(vm)
      self.tableView.reloadData()
      self.validateSaveButton()
    }
  }
  
  func updateRecipeInstruction() {
    guard let vc = R.storyboard.addInstruction.addInstructionController() else { return }
    vc.onAccept = { [weak self] instruction in
      guard let self = self else { return }
      self.viewModel.recipeVM.instruction = instruction
      self.tableView.reloadData()
      self.validateSaveButton()
    }
    
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    
    navigationController?.present(nav, animated: true)
  }
  
  func validateSaveButton() {
    let recipeVM = viewModel.recipeVM
    if recipeVM.name.count > 0 ||
        recipeVM.ingredients.count > 0 ||
        recipeVM.instruction.count > 0 {
      navigationItem.rightBarButtonItem?.isEnabled = true
    }
  }
}

// MARK: - Events
private extension EditRecipeController {
  @objc
  func didTapSaveButton() {
    SVProgressHUD.show()
    
    viewModel.updateRecipe { result in
      SVProgressHUD.dismiss()
      
      switch result {
      case .success(_):
        SVProgressHUD.showSuccess(withStatus: "Recipe has been successfully posted.")
      case .failure(let error):
        SVProgressHUD.showError(withStatus: error.localizedDescription)
      }
    }
  }
  
  @objc
  func didTapCloseButton() {
    navigationController?.dismiss(animated: true)
  }
  
  @IBAction func addRecipeImageButtonTapped(_ sender: Any) {
  }
}

// MARK: - Delegates
extension EditRecipeController: UITableViewDelegate, UITableViewDataSource {
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
    switch section {
    case 1:
      if let headerView = recipeSectionView(with: "Ingredients", isAddButtonHidden: false) {
        headerView.onAddIngredient = { [weak self] in
          self?.addIngredient()
        }
        return headerView
      }
    case 2:
      if let headerView = recipeSectionView(with: "Instructions") {
        headerView.addButton.isHidden = true
        return headerView
      }
    default:
      return nil
    }
    
    return nil
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    return section == 0 ? 0 : 44
  }
}

// MARK: - Helpers
private extension EditRecipeController {
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
    
    cell.onUpdateRecipeTitle = { [weak self] in
      self?.updateRecipeTitle()
    }
    
    cell.enableTapGesture()
    
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
    
    cell.onUpdateRecipeInstruction = { [weak self] in
      self?.updateRecipeInstruction()
    }
    
    cell.enableTapGesture()
    
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
