//
//  DashboardController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit
import FirebaseAuth

class DashboardController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Properties
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setups()
  }
}

// MARK: - Setups
private extension DashboardController {
  func setups() {
    setupNavigationBar()
    setupTableView()
  }
  
  func setupNavigationBar() {
    navigationItem.title = "My Recipe App"
    
    let signOutBtn = UIBarButtonItem(
      image: R.image.iconLogout(),
      style: .done,
      target: self,
      action: #selector(didTapLogout)
    )

    let addRecipeBtn = UIBarButtonItem(
      image: R.image.iconPlus(),
      style: .done,
      target: self,
      action: #selector(didTapAddRecipe)
    )

    navigationItem.rightBarButtonItems = [signOutBtn, addRecipeBtn]
  }
  
  func setupTableView() {
    tableView.addPadding()
    tableView.registerCells(nibs: [R.nib.recipeCell])
  }
}

// MARK: - Events
private extension DashboardController {
  @objc
  func didTapLogout() {
    try? Auth.auth().signOut()
  }
  
  @objc
  func didTapAddRecipe() {
    try? Auth.auth().signOut()
  }
}

// MARK: - Delegates
extension DashboardController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.recipeCell.name
    ) as? RecipeCell
    else { return UITableViewCell() }
    
    return cell
  }
}
