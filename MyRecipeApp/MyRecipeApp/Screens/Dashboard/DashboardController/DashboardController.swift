//
//  DashboardController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class DashboardController: UITabBarController {
  
  // MARK: - IBOutlet
  
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
    setupTabs() 
  }
  
  func setupTabs() {
    setViewControllers([
      homeController(),
      myRecipeController()
    ], animated: true)
  }
  
  func homeController() -> UINavigationController {
    guard let vc = R.storyboard.home.homeController()
    else { return UINavigationController() }
    
    let vm = HomeViewModel(firestoreServices: AppDelegate.shared.appServices.firestoreServices)
    vc.viewModel = vm
    
    let nav = UINavigationController(rootViewController: vc)
    nav.tabBarItem.title = "Home"
    nav.tabBarItem.image = R.image.iconHome()
    nav.modalPresentationStyle = .fullScreen
    
    return nav
  }
  
  func myRecipeController() -> UINavigationController {
    guard let vc = R.storyboard.myRecipe.myRecipeController()
    else { return UINavigationController() }
    
    let nav = UINavigationController(rootViewController: vc)
    nav.tabBarItem.title = "My Recipe"
    nav.tabBarItem.image = R.image.iconList()
    nav.modalPresentationStyle = .fullScreen
    
    return nav
  }
}

// MARK: - Events
private extension DashboardController {
}

// MARK: - Delegates
