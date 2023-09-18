//
//  AppDelegate+RootViewController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

extension AppDelegate {
  func updateRootViewController() {
    guard appServices.sessionService.isActive else {
      return setRootViewControllerToSignIn()
    }
    
    setRootViewControllerToDashboard()
  }
}

extension AppDelegate {
  func setRootViewControllerToSignIn() {
    guard let vc = R.storyboard.signIn.signInController() else { return }
    
    let vm = SignInViewModel()
    vc.viewModel = vm
    
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    self.window?.rootViewController = nav
  }
  
  func setRootViewControllerToDashboard() {
    guard let vc = R.storyboard.dashboard.dashboardController() else { return }
    
    self.window?.rootViewController = vc
  }
}
