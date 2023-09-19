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
    let homeVC = homeController()
    
    setViewControllers([homeVC], animated: true)
  }
  
  func homeController() -> UINavigationController {
    guard let vc = R.storyboard.home.homeController()
    else { return UINavigationController() }
    
    let nav = UINavigationController(rootViewController: vc)
    nav.tabBarItem.title = "Home"
    nav.tabBarItem.image = R.image.iconHome()
    nav.modalPresentationStyle = .fullScreen
    
    return nav
  }
}

// MARK: - Events
private extension DashboardController {
}

// MARK: - Delegates
