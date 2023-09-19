//
//  MyRecipeController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class MyRecipeController: UIViewController {
  
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
private extension MyRecipeController {
  func setups() {
    setupNavigationBar()
    setupTableView()
  }
  
  func setupNavigationBar() {
    navigationItem.title = "My Own Recipe List"

    let addRecipeBtn = UIBarButtonItem(
      image: R.image.iconAdd(),
      style: .done,
      target: self,
      action: #selector(didTapAddRecipe)
    )

    navigationItem.rightBarButtonItem = addRecipeBtn
  }
  
  func setupTableView() {
    tableView.addPadding()
    tableView.registerCells(nibs: [R.nib.myRecipeCell])
  }
}

// MARK: - Events
private extension MyRecipeController {
  @objc
  func didTapAddRecipe() {
  }
}

// MARK: - Delegates
extension MyRecipeController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.myRecipeCell.name
    ) as? MyRecipeCell
    else { return UITableViewCell() }
    
    return cell
  }
}
