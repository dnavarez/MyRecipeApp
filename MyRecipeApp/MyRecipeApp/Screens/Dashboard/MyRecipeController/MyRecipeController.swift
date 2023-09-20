//
//  MyRecipeController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class MyRecipeController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Properties
  var viewModel: MyRecipeViewModelProtocol!
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setups()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchRecipes()
  }
}

// MARK: - Setups
private extension MyRecipeController {
  func setups() {
    setupNavigationBar()
    setupTableView()
  }
  
  func setupNavigationBar() {
    navigationItem.title = "My Own Recipe List"
    
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
    setupTableViewRefreshControl()
  }
  
  func setupTableViewRefreshControl() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(didRefreshTable), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
}

// MARK: - Firebase
private extension MyRecipeController {
  func fetchRecipes() {
    SVProgressHUD.show()
    
    viewModel.fetchRecipes { [weak self] result in
      SVProgressHUD.dismiss()
      
      switch result {
      case .success(_):
        self?.tableView.reloadData()
      case .failure(let error):
        SVProgressHUD.showError(withStatus: error.localizedDescription)
      }
    }
  }
}

// MARK: - Events
private extension MyRecipeController {
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
    
    let vm = AddRecipeViewModel(firestoreServices: AppDelegate.shared.appServices.firestoreServices)
    vc.viewModel = vm
    
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    
    navigationController?.present(nav, animated: true)
  }
  
  @objc
  func didRefreshTable() {
    fetchRecipes()
  }
}

// MARK: - Delegates
extension MyRecipeController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.recipeCell.name
    ) as? RecipeCell
    else { return UITableViewCell() }
    
    let vm = viewModel.items[indexPath.row]
    cell.viewModel = vm
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let vc = R.storyboard.recipeDetail.recipeDetailController() else { return }
    
    let vm = viewModel.items[indexPath.row]
    vc.viewModel = vm
    
    navigationController?.pushViewController(vc, animated: true)
  }
}
