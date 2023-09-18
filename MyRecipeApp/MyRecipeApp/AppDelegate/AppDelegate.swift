//
//  AppDelegate.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let vc = R.storyboard.signIn.signInController() else { return false }
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    
    self.window?.rootViewController = nav
    self.window?.makeKeyAndVisible()
    
    return true
  }
}

