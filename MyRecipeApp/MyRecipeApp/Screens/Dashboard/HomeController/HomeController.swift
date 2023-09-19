//
//  HomeController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit
import FirebaseAuth

class HomeController: UIViewController {
  
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
private extension HomeController {
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
      image: R.image.iconAdd(),
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
private extension HomeController {
  @objc
  func didTapLogout() {
    let alertVC = UIAlertController(
      title: "Are you sure you want to log out?",
      message: nil,
      preferredStyle: .alert
    )
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let logoutAction = UIAlertAction(title: "Logout", style: .default, handler: { _ in
      try? Auth.auth().signOut()
      AppDelegate.shared.updateRootViewController()
    })
    
    alertVC.addAction(cancelAction)
    alertVC.addAction(logoutAction)
    
    self.present(alertVC, animated: true)
  }
  
  @objc
  func didTapAddRecipe() {
    guard let vc = R.storyboard.addRecipe.addRecipeController() else { return }
    
    let vm = AddRecipeViewModel(createService: AppDelegate.shared.appServices.createService)
    vc.viewModel = vm
    
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    
    navigationController?.present(nav, animated: true)
  }
}

// MARK: - Delegates
extension HomeController: UITableViewDelegate, UITableViewDataSource {
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
